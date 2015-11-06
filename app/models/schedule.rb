class Schedule < ActiveRecord::Base

  belongs_to :root_task, class_name: 'Task'
  has_many :tasks, -> {order(created_at: :asc)}, dependent: :destroy

  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true

  # == Validators ==
  validates :root_task, presence: true,
                        on: :update,
                        unless: 'tasks.empty?'

  # == Instance Methods ==

  # The list of Tasks that are currently processing
  # @return [Array[Task]] The list of running tasks
  def running_tasks
    raise NotImplementedError, 'Not ready yet!'
  end

  # The list of Tasks that are done
  # @return [Array[Task]] The list of running tasks
  def complete_tasks
    raise NotImplementedError, 'Not ready yet!'
  end

  # The list of Tasks that are ready to be passed into a Job
  # @return [Array[Task]] The list of running tasks
  def next_tasks
    raise NotImplementedError, 'Not ready yet!'
  end

  # The list of Tasks associated with failed jobs.
  # These will need to be handled appropriately (e.g. restarted).
  # @return [Array[Task]] The list of running tasks
  def failed_tasks
    raise NotImplementedError, 'Not ready yet!'
  end

end
