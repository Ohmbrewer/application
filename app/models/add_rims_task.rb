class AddRimsTask < Task

  # == Special Attributes ==

  # This gives us a way to store the data that will be sent with all updates.
  # Subclasses that have additional update data to send (e.g. Thermostat & RIMS)
  # will have additional store_accessors
  store_accessor :update_data, :safety_sensor_state,
                               :pump_state,
                               tube: [
                                   :target_temperature, :sensor_state, :element_state
                               ]

  # Converts the stored JSON update_data fields into a
  # something the Rhizome will understand
  # @abstract Task subclasses *might* need to override this to function
  def to_particle_args
    super.merge({
        safety_sensor_state: safety_sensor_state,
        pump_state:          pump_state,
        tube:                {
            target_temperature: target_temperature,
            sensor_state:       sensor_state,
            element_state:      element_state
        }
    })
  end

end
