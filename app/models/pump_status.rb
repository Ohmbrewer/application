class PumpStatus < EquipmentStatus
  belongs_to :pump,
             inverse_of: :pump_statuses
  store_accessor :data, :speed

  def to_speed_json
    JSON.generate(speed: speed)
  end

  class << self
    # Identifies which Equipment Type this status message applies to
    def equipment_class
      Pump
    end

    # # == SSE Methods ==
    #
    # # Event channel for broadcasting SSE's
    # def event_channel
    #   {event: 'pump_status_update'}
    # end
  end
end
