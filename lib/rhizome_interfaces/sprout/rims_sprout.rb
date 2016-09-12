require 'rhizome_interfaces/sprout/sprout'
module RhizomeInterfaces
  module RIMSSprout
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
        rhizome.recirculating_infusion_mash_systems.select {|p| p.rhizome_eid.to_i == rhizome_eid }.first
      end

      # The RIMS has additional parameters to set on Update. Supply them keyed as follows:
      # * Safety Sensor State (:safety_sensor_state)
      # * Recirculation Pump State (:pump_state)
      # * Tube Params (:tube)
      # @param extra [Hash] Hash of extra arguments
      # @return [String] The extra arguments, ready for appending
      def parse_extra_args(extra={})
        "#{extra[:safety_sensor_state]},#{extra[:pump_state]}" <<
            Thermostat::parse_extra_args(extra[:tube])
      end

    end

    # == Instance Methods to Include ==
    def rhizome_type_name
      'rims'
    end

    def rhizome_eid
      tube.rhizome_eid
    end

    # Produces a String of arguments for the Sprout's pins, formatted in the way that the Particle Function
    # on the Rhizome expects for /add
    # @return [String] The argument string for /add
    def add_pin_args_str
      "#{tube.add_pin_args_str},#{recirculation_pump.add_pin_args_str}"
    end

  end
end
