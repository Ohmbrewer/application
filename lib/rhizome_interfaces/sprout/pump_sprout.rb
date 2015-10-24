require 'rhizome_interfaces/sprout/sprout'
module RhizomeInterfaces
  module PumpSprout
    include Sprout

    # This automagically adds the ClassMethods to the ClassMethods of Sprout
    def self.included(base)
      base.extend(ClassMethods)
      interceptor = const_set("#{base.name}Interceptor", Module.new)
      base.prepend interceptor
    end

    # == Class Methods to Include ==
    module ClassMethods

      # Locates the Equipment subclass, Thermostat, or RIMS instance associated with a
      # given Rhizome Sprout ID.
      # @param rhizome [Rhizome] The Rhizome with the desired Sprout
      # @param rhizome_eid [Integer] The Rhizome Sprout ID / Equipment ID
      # @return [Equipment|Thermostat|Recirculating_Infusion_Mash_System] The sprout instance
      def find_by_rhizome_eid(rhizome, rhizome_eid)
        rhizome.pumps.select {|p| p.rhizome_eid.to_i == rhizome_eid }.first
      end

      # The Pump has optional parameters to set on Update. Supply them keyed as follows:
      # * Speed (:speed)
      # @param extra [Hash] Hash of extra arguments
      # @return [String] The extra arguments, ready for appending
      def parse_extra_args(extra={})
        "#{extra[:speed].nil? ? '' : "#{extra[:speed]}"}"
      end

    end

    # == Instance Methods to Include ==
    def rhizome_eid
      control_pin
    end

    def rhizome_type_name
      'pump'
    end

  end
end
