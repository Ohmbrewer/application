module RhizomeInterfaces
  module Errors

    class RhizomeBadFunctionError < RhizomeError

      attr_accessor :function_name

      def initialize(msg='', fn)
        super
      end

      def message
        "The Rhizome doesn't support the \"#{function_name}\" function! " <<
        'Check your equipment!'
      end
    end

  end
end