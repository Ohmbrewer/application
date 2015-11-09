class Schedule < ActiveRecord::Base

  belongs_to :root_task, class_name: 'Task'
  has_many :tasks, -> {order(created_at: :asc)}, dependent: :destroy

  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true

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

end
