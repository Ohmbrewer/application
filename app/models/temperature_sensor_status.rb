class TemperatureSensorStatus < EquipmentStatus
  belongs_to :temperature_sensor,
             inverse_of: :temperature_sensor_statuses
  store_accessor :data, :temperature, :last_read_time

  # == Validators ==
  validates :temperature, presence: true
  validates :last_read_time, presence: true

  def to_gauge_json
    JSON.generate(temperature: temperature, last_read_time: last_read_time)
  end

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
