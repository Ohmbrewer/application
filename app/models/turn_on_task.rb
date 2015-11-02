require 'rhizome_interfaces/sprout/sprout'
class TurnOnTask < Task

  # == Instance Methods ==

  # We always want this Task to try to turn the Equipment on
  def initialize
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

  # The EquipmentStatus variant to watch for notifications of
  # @raise [NoMethodError] If not supplied by the subclass
  # @return [EquipmentStatus] The EquipmentStatus subclass to watch for updates of
  # @todo Doesn't handle equipment groupings (RIMS, Thermostat...)
  def status_class
    "#{equipment.class.name}Status"
  end

  # Performs the appropriate holding action for the Task
  # @abstract This should be overridden by the subclass
  # @param last_check [EquipmentStatus] The last status associated with the Task
  def do_hold(last_check)
    if last_check.off?
      # If the status report says the Equipment is offline, try
      # resending the Task. If that doesn't work, fail and punt to the launcher.
      hold_failure! unless send_to_rhizome
    end
  end

end
