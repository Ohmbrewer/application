require 'rhizome_interfaces/errors/rhizome_error'
module RhizomeInterfaces
  module Errors

    class RhizomeArgumentError < RhizomeError

      attr_accessor :function_name, :error_code

      def initialize(fn, error_code, msg='')
        super(msg)
        @function_name ||= fn
        @error_code ||= error_code
      end

      def message
        "The /#{function_name} function returned a Failure Code of #{error_code}!" <<
        ' You probably need to fix your argument string.'
      end
    end

  end
end