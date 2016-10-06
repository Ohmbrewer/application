module Scheduler
  module TaskTypes
    module HoldingTask
      def holds?
        true
      end

      def percent_complete
        if done?
          100
        elsif start_time.nil?
          0
        else
          (Time.now.to_i - start_time) / duration
        end
      end
    end
  end
end
