class AddPumpTask < Task

  # == Special Attributes ==

  # This gives us a way to store the data that will be sent with all updates.
  # Subclasses that have additional update data to send (e.g. Thermostat & RIMS)
  # will have additional store_accessors
  store_accessor :update_data, :speed

  # Converts the stored JSON update_data fields into a
  # something the Rhizome will understand
  # @abstract Task subclasses *might* need to override this to function
  def to_particle_args
    super.merge({
        speed: speed
    })
  end


end
