require 'rhizome_interfaces/sprout/thermostat_sprout'
class RunThermostatTask < Task

  store_accessor :update_data, :target_temperature

  # == Validators ==
  validate :thermostat_sprout_validation
  validates :thermostat, presence: true
  validates :ramp_estimate, presence: true
  validates_numericality_of :ramp_estimate, { greater_than_or_equal_to: 0 }
  validates_numericality_of :target_temperature, {
                                                   greater_than_or_equal_to: -69,
                                                   less_than_or_equal_to: 200
                                                 }

  # Ensures that the provided Sprout is a Thermostat
  def thermostat_sprout_validation
    if sprout_name.nil? || !sprout_name.start_with?('Thermostat')
      errors.add(:sprout, 'must be a Thermostat.')
    end
  end

  # == Instance Methods ==

  def holds?
    true
  end

  def ramps?
    true
  end

  # Performs the appropriate holding action for the Task
  # @abstract This should be overridden by the subclass
  # @param last_check [EquipmentStatus] The last status associated with the Task
  def do_ramp(last_check)
    if last_check.off?
      # If the status report says the Equipment is offline, try
      # resending the Task. If that doesn't work, fail and punt to the launcher.
      ramp_failure! unless send_to_rhizome
    elsif last_check.temperature >= target_temperature
      # If we reach the target temperature, transition into holding.
      ready!
    end
  end

  # Converts the stored JSON update_data fields into a
  # something the Rhizome will understand
  # @abstract Task subclasses *might* need to override this to function
  def to_particle_args
    super.merge({
      target: target_temperature.to_f
    })
  end

end
