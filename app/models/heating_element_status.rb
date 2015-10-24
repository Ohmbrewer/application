class HeatingElementStatus < EquipmentStatus

  store_accessor :data, :voltage

  class << self

    # Identifies which Equipment Type this status message applies to
    def equipment_class
      HeatingElement
    end

    # # == SSE Methods ==
    #
    # # Event channel for broadcasting SSE's
    # def event_channel
    #   {event: 'heating_element_status_update'}
    # end

  end

end
