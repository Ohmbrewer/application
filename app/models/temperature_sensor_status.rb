class TemperatureSensorStatus < EquipmentStatus

  store_accessor :data, :temperature, :last_read_time

  # == Validators ==
  validates :temperature, presence: true
  validates :last_read_time, presence: true

  class << self

    # Identifies which Equipment Type this status message applies to
    def equipment_class
      TemperatureSensor
    end

    # # == SSE Methods ==
    #
    # # Event channel for broadcasting SSE's
    # def event_channel
    #   {event: 'temperature_sensor_status_update'}
    # end

  end
end
