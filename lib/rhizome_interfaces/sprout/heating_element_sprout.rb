require 'rhizome_interfaces/sprout/sprout'
module RhizomeInterfaces
  module HeatingElementSprout
    include Sprout

    # This automagically adds the ClassMethods to the ClassMethods of Sprout
    def self.included(base)
      base.extend(ClassMethods)
    end

    # == Class Methods to Include ==
    module ClassMethods
      include Sprout::ClassMethods

      # Locates the Equipment subclass, Thermostat, or RIMS instance associated with a
      # given Rhizome Sprout ID.
      # @param rhizome [Rhizome] The Rhizome with the desired Sprout
      # @param rhizome_eid [Integer] The Rhizome Sprout ID / Equipment ID
      # @return [Equipment|Thermostat|Recirculating_Infusion_Mash_System] The sprout instance
      def find_by_rhizome_eid(rhizome, rhizome_eid)
        raise ArgumentError, 'No Rhizome specified!' if rhizome.nil?
        raise ArgumentError, 'No Rhizome Equipment ID specified!' if rhizome_eid.nil?
        rhizome.heating_elements.select {|p| p.rhizome_eid.to_i == rhizome_eid }.first
      end

      # The Heating Element has optional parameters to set on Update. Supply them keyed as follows:
      # * Voltage (:voltage)
      # @param extra [Hash] Hash of extra arguments
      # @return [String] The extra arguments, ready for appending
      def parse_extra_args(extra={})
        "#{extra[:voltage].nil? ? '' : ",#{extra[:voltage]}"}"
      end

    end

    # == Instance Methods to Include ==

    def rhizome_eid
      control_pin
    end

    def rhizome_type_name
      'heat'
    end

    # Produces a String of arguments for the Sprout's pins, formatted in the way that the Particle Function
    # on the Rhizome expects for /add
    # @return [String] The argument string for /add
    def add_pin_args_str
      "#{control_pin},#{power_pin.nil? || power_pin.empty? ? '-1' : power_pin}"
    end

  end
end
