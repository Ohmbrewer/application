class Schedule < ActiveRecord::Base

  belongs_to :root_task, class_name: 'Task'
  has_many :tasks, -> {order(created_at: :asc)}, dependent: :destroy
  has_many :schedule_profiles, dependent: :destroy
  has_many :equipment_profiles, through: :schedule_profiles

  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true

  # == Scopes ==
  scope :non_batch_records, -> { where.not(id: Recipe.where
                                                     .not(batch_id: nil)
                                                     .joins(:schedule)
                                                     .pluck(:schedule_id)) }
  scope :batch_records, -> { where(id: Recipe.where
                                             .not(batch_id: nil)
                                             .joins(:schedule)
                                             .pluck(:schedule_id)) }

  # == Validators ==
  validates :root_task, presence: true,
                        on: :update,
                        unless: 'tasks.empty? || tasks.none?{ |t| !t.id.nil? }'

  # == Instance Methods ==

  # Whether the Schedule is in a state where it can be processed by a ScheduleJob.
  # So far, the requirements are:
  # 1) The root task is set
  # 2) All tasks other than the root task have a parent
  # @return [TrueFalse] True if the Schedule can be run
  def runnable?
    !root_task.nil? &&
    tasks.all? { |t| t == root_task ? true : (!t.parent.nil?) }
  end

  # The list of Tasks that are currently processing
  # @return [Array[Task]] The list of running tasks
  def running_tasks
    tasks.select { |t| !t.done? && !t.queued? && !t.failed? }
  end

  # The list of Tasks that have been triggered but are blocked waiting for processing
  # @return [Array[Task]] The list of running tasks
  def queued_tasks
    tasks.select { |t| t.queued? }
  end

  # The list of Tasks that are done
  # @return [Array[Task]] The list of running tasks
  def complete_tasks
    tasks.select { |t| t.done? }
  end

  # The list of Tasks that are done
  # @return [Array[Task]] The list of running tasks
  def all_tasks_complete?
    complete_tasks.length == tasks.length
  end

  # The list of Tasks that are ready to be passed into a Job
  # @return [Array[Task]] The list of running tasks
  def next_tasks
    running_tasks.select { |t| t.children }
  end

  # The list of Tasks associated with failed jobs.
  # These will need to be handled appropriately (e.g. restarted).
  # @return [Array[Task]] The list of running tasks
  def failed_tasks
    tasks.select { |t| t.failed? }
  end

  # The list of Tasks queued on a given equipment instance
  # @param [Equipment] equipment The equipment in question
  # @return [Array[Task]] The list of tasks queued for that Equipment
  def tasks_queued_for_equipment(equipment)
    queued_tasks.select { |t| (t.equipment == equipment) }
  end

  # The list of Tasks queued on a given equipment instance
  # @param [Equipment] equipment The equipment in question
  # @return [Array[Task]] The list of tasks running on that Equipment
  def tasks_running_on_equipment(equipment)
    running_tasks.select { |t| (t.equipment == equipment) }
  end

  def deep_dup
    new_schedule = super
    new_schedule.name = "#{new_schedule.name} (Copy)"

    # Now, carefully duplicate the Task hierarchy...
    root_task.self_and_descendants.each do |t|
      new_task = t.dup

      unless t.parent.nil?
        # Need to find the duplicate of the parent. Don't do this part for the Root Task, naturally.
        pi = tasks.ids.find_index{ |a| a == t.parent.id }
        new_task.parent = new_schedule.tasks[pi]
      end

      # Add the Task to the list
      new_schedule.tasks << new_task

      # Use the dup of the Root Task as the new Root Task
      new_schedule.root_task = new_schedule.tasks.first if new_schedule.tasks.length == 1
    end

    new_schedule
  end

  # Finds the Batch associated with this Schedule (since we don't actually supply the association)
  # @return [Batch] The Batch that owns the Recipe that owns this Schedule
  def batch
    r = Recipe.where(schedule: self).first
    r.nil? ? nil : Batch.find(r.batch_id)
  end

  # Clear any running TaskJobs that the Schedule kicked off.
  # Used when the job is destroyed, essentially for
  # when we want a full stop.
  def clean_up_task_jobs

    # Kill any running tasks
    tasks.each do |task|
      Delayed::Job.where(queue: task.queue_name).destroy_all
    end

    # TODO: We should really turn off all Sprouts instead of dumping them...
    # Dump the Sprouts for all the Rhizomes
    unless batch.nil?
      batch.rhizomes.each do |r|
        ClearRhizomeSproutsJob.set(queue: "#{r.name}_clear_sprouts")
                              .perform_now(r)
      end
      Delayed::Job.where(queue: batch.queue_name).destroy_all
    end
  end

end
