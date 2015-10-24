module RhizomeInterfaces
  # == Relay Validations ==
  # These are some standard validations that will apply to Equipment based on the Relay class in the Rhizome firmware.
  module RelayValidations

    # Ensures that the control pin and the power pin are set to different values or no value.
    def pin_match_validation
      if (control_pin == power_pin) && control_pin != ''
        errors.add(:control_pin, ' may not be the same as the Power Pin.')
      end
    end

    # Determines if a given pin is currently in use for the Rhizome that the
    # Equipment will be attached to.
    # @param [Integer] pin The pin number
    # @return [True|False] Whether the pin is in use
    def pin_in_use?(pin)
      if rhizome.nil? || rhizome.equipments.nil? || rhizome.equipments.empty?
        false
      else
        unless pin.blank?
          rhizome.equipments
                 .select{|e| e.id != id }
                 .any? {|e| e.pins[:control_pin] == pin || e.pins[:power_pin] == pin || e.pins[:data_pin] == pin}
        end
      end
    end

    # Ensures that the assigned control pin is not already in use.
    def control_pin_in_use_validation
      errors.add(:control_pin, ' is already in use.') if pin_in_use? control_pin
    end

    # Ensures that the assigned power pin is not already in use.
    def power_pin_in_use_validation
      errors.add(:power_pin, ' is already in use.') if pin_in_use? power_pin
    end
  end
end