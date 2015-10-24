class AddTemperatureSensorTask < Task

  # == Special Attributes ==

  # This gives us a way to store the data that will be sent with all updates.
  # Subclasses that have additional update data to send (e.g. Thermostat & RIMS)
  # will have additional store_accessors
  store_accessor :update_data, :speed

end
