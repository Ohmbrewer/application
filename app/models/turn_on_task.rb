require 'rhizome_interfaces/sprout/sprout'
class TurnOnTask < Task
  # == Instance Methods ==

  # We always want this Task to try to turn the Equipment on
  def initialize(attributes = nil, options = {})
    super
    update_data[:state] = 'ON'
  end

  # We always want this Task to try to turn the Equipment on
  def state=(s)
    super 'ON'
  end

  def holds?
    true
  end

  def on?
    state == 'ON'
  end

  def off?
    state == 'OFF'
  end
end
