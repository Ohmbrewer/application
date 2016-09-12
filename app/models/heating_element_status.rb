class HeatingElementStatus < EquipmentStatus
  belongs_to :heating_element,
             inverse_of: :heating_element_statuses
  store_accessor :data, :voltage

  def to_voltage_json
    JSON.generate(voltage: voltage)
  end

  class << self
    # Identifies which Equipment Type this status message applies to
    def equipment_class
      HeatingElement
    end

    # == SSE Methods ==

    # Event channel for broadcasting SSE's
    def event_channel
      {event: 'heating_element_status_update'}
    end
  end
end
