require 'rhizome_interfaces/sprout/sprout'
class AddEquipmentTask < Task

  # == Subclass scopes ==
  # These scopes make so anything that references Equipment generally
  # may also reference each of these subclasses specifically, automagically.
  scope :add_pump_tasks, -> { where(type: 'AddPumpTask') }
  scope :add_heating_element_tasks, -> { where(type: 'AddHeatingElementTask') }
  scope :add_temperature_sensor_tasks, -> { where(type: 'AddTemperatureSensorTask') }
  scope :add_thermostat_tasks, -> { where(type: 'AddThermostatTask') }
  scope :add_rims_tasks, -> { where(type: 'AddRimsTask') }

  # == Instance Methods ==

  # Converts the stored JSON update_data fields into a
  # something the Rhizome will understand
  # @abstract Task subclasses *might* need to override this to function
  def to_particle_args
    super # Pretty sure we're good for now...
  end

  # Updates the Task based on the Status supplied.
  # @abstract Task subclasses must override this to function
  # @raise [NoMethodError] If not supplied by the subclass
  # @param status [EquipmentStatus] An EquipmentStatus update
  def process_status(status)
    raise NoMethodError, 'AddEquipmentTask-based classes do not process status!'
  end

end
