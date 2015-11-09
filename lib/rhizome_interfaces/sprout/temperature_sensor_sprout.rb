require 'rhizome_interfaces/sprout/sprout'
module RhizomeInterfaces
  module TemperatureSensorSprout
    include Sprout

    # This automagically adds the ClassMethods to the ClassMethods of Sprout
    def self.included(base)
      base.extend(ClassMethods)
    end

    # == Class Methods to Include ==
    module ClassMethods

      # Locates the Equipment subclass, Thermostat, or RIMS instance associated with a
      # given Rhizome Sprout ID.
      # @param rhizome [Rhizome] The Rhizome with the desired Sprout
      # @param rhizome_eid [Integer] The Rhizome Sprout ID / Equipment ID
      # @return [Equipment|Thermostat|Recirculating_Infusion_Mash_System] The sprout instance
      def find_by_rhizome_eid(rhizome, rhizome_eid)
        rhizome.temperature_sensors.select {|p| p.rhizome_eid.to_i == rhizome_eid }.first
      end

      # Formats a String of additional arguments to supplement the defaults in #to_args_str
      # @abstract This method must be implemented to pass those extra arguments.
      # @param extra [Hash] Hash of extra arguments
      # @return [String] The extra arguments, ready for appending
      def parse_extra_args(extra={})
        ''
      end

    end

    # == Instance Methods to Include ==
    def rhizome_eid
      onewire_id
    end

    def rhizome_type_name
      'temp'
    end

  end
end
