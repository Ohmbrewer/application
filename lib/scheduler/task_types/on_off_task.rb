module Scheduler
  module TaskTypes
    module OnOffTask
      def on?
        state == 'ON'
      end

      def off?
        state == 'OFF'
      end
    end
  end
end
