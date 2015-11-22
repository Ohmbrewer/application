require 'rhizome_interfaces/sprout/sprout'
class TurnOffTask < Task

  # == Instance Methods ==

  # We always want this Task to try to turn the Equipment off
  def initialize(attributes = nil, options = {})
    super
    update_data[:state] = 'OFF'
  end

  # We always want this Task to try to turn the Equipment off
  def state=(s)
    super 'OFF'
  end

  def holds?
    true
  end

end
