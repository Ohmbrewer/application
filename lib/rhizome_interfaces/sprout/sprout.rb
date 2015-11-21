# == Sprout Interface methods ==
# Using this module to extend your model should allow you to interact with the Rhizome.
#
# For this to work, your model needs:
# rhizome : A reference the Rhizome you'd like to send messages to
# type : The standardized type name for the Equipment you're attaching, such as "Pump" or "RIMS"
# rhizome_eid : The Equipment ID of the Equipment instance on the Rhizome side
# rhizome_type : The Equipment Type of the Equipment instance on the Rhizome side
#
# The combination of the Rhizome and the Equipment ID represent a unique key that identifies the
# particular piece of Equipment amongst all Equipment that Ohmbrewer knows of. This information makes it fairly simple to
# determine the appropriate endpoint(s) to connect to.
module RhizomeInterfaces
  module Sprout

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
        raise NotImplementedError, "This method probably needs to get implemented in RhizomeInterfaces::Sprout::#{type}Sprout"
      end

      # Formats a String of additional arguments to supplement the defaults in #to_args_str
      # @abstract This method must be implemented to pass those extra arguments.
      # @param extra [Hash] Hash of extra arguments
      # @return [String] The extra arguments, ready for appending
      def parse_extra_args(extra={})
        raise NotImplementedError, "This Rhizome Equipment Type (#{type}) does not have extra arguments"
      end

    end

    # Provides the expected identifier on the Rhizome's side for the Equipment
    def rhizome_eid
      raise NotImplementedError, 'No Rhizome Equipment ID method provided!'
    end

    # Provides the expected identifier on the Rhizome's side for the Equipment Type name
    def rhizome_type_name
      raise NotImplementedError, 'No Rhizome Equipment Type method provided!'
    end

    # Produces a String of arguments formatted in the way that the Particle Function on the Rhizome expects
    def to_args_str(args = {})
      extra_args = self.class.parse_extra_args(args)
      extra_args.prepend(',') if extra_args.length > 0
      "#{rhizome_type_name},#{rhizome_eid},#{args[:current_task]},#{args[:state]},#{args[:stop_time]}#{extra_args}"
    end

    # Sends the provided information to the Rhizome's appropriate Particle Function endpoint.
    # @return [TrueFalse] Whether the update was successfully sent
    def send_update(args = {})
      Rails.logger.info "Sending a message to the #{type} of: " <<
                        "#{to_args_str(args)}"
      begin
        rhizome.particle_device
               .connection
               .function 'update',
                         to_args_str(args)
      rescue Particle::BadRequest => e
        msg = 'Lost contact with Rhizome or the Rhizome doesn\'t support ' <<
              'the "update" function! Check your equipment!'
        Rails.logger.error msg
        return false
      end
      true
    end

  end
end