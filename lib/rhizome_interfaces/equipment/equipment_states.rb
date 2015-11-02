# Provides a single point of contact for ensuring the data we store on the State member of Equipment
# on the Rhizome makes sense.
module RhizomeInterfaces
  module EquipmentStates

    # Lists the acceptable states for a Sprout
    # @return [Array] List of acceptable states
    def acceptable_states
      %w(on off --)
    end

    # Overridden getter for :state that ensures it will be presented in the expected format
    # @return [String] A standardized format for :state
    def state
      super.upcase
    end

    # Overridden setter for :state that ensures it will be stored in the expected format
    # @raise [ArgumentError] If the supplied String isn't one of the acceptable inputs
    # @param s [String] The new state
    def state=(s)
      unless acceptable_states.any? { |a| a.casecmp(s).zero? }
        raise ArgumentError, "Please use one of the acceptable states: #{acceptable_states}"
      end
      super
    end

  end
end