module RhizomeInterfaces
  # == OneWire Validations ==
  # These are some standard validations that will apply to Equipment based on the OneWire class in the Rhizome firmware.
  module OneWireValidations

    # Determines if a given index is currently in use for the Rhizome that the
    # Equipment will be attached to.
    # @param [Integer] index The index number
    # @return [True|False] Whether the index is in use
    def index_in_use?(index)
      if equipment_profile.nil? || equipment_profile.equipments.nil? || equipment_profile.equipments.empty?
        false
      else
        unless index.blank?
          self.equipment_profile.equipments
                                .select {|e| e.id != id && e.pins[:onewire_index].present? }
                                .any? {|e| e.pins[:onewire_index].to_i == index.to_i }
        end
      end
    end

    # Ensures that the assigned index is not already in use.
    def index_in_use_validation
      errors.add(:onewire_index, 'is already in use.') if index_in_use? onewire_index
    end
  end
end