class PumpStatus < EquipmentStatus

  store_accessor :data, :speed

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
