require 'rhizome_interfaces/errors/rhizome_error'
module RhizomeInterfaces
  module Errors

    class RhizomeUnresponsiveError < RhizomeError
      def message
        'The Rhizome returned no response. ' <<
        'Please check your network connections and try again.'
      end
    end

  end
end