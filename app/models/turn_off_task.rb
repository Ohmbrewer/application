require 'scheduler/task_types/holding_task'
require 'scheduler/task_types/on_off_task'
class TurnOffTask < Task
  include Scheduler::TaskTypes::HoldingTask
  include Scheduler::TaskTypes::OnOffTask

  # We always want this Task to try to turn the Equipment off
  def initialize(attributes = nil, options = {})
    super
    update_data[:state] = 'OFF'
  end

  # We always want this Task to try to turn the Equipment off
  def state=(s)
    raise ArgumentError, 'The state of TurnOffTasks is always \'OFF\'' unless s.casecmp('OFF').zero?
    super
  end
end
