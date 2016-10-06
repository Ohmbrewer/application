require 'scheduler/task_types/holding_task'
require 'scheduler/task_types/on_off_task'
class TurnOnTask < Task
  include Scheduler::TaskTypes::HoldingTask
  include Scheduler::TaskTypes::OnOffTask

  # We always want this Task to try to turn the Equipment on
  def initialize(attributes = nil, options = {})
    super
    update_data[:state] = 'ON'
  end

  # We always want this Task to try to turn the Equipment on
  def state=(s)
    raise ArgumentError, 'The state of TurnOnTasks is always \'ON\'' unless s.casecmp('ON').zero?
    super
  end
end
