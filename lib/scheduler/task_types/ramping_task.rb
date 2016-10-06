module Scheduler
  module TaskTypes
    module RampingTask
      def holds?
        true
      end

      def ramps?
        true
      end

      def percent_ramp_complete
        if ramping?
          (Time.now.to_i - ramp_start_time) / ramp_estimate
        elsif start_time.nil?
          0
        else
          100
        end
      end

      def percent_complete
        if done?
          100
        elsif ramp_start_time.nil?
          0
        else
          (Time.now.to_i - hold_start_time) / duration
        end
      end
    end
  end
end
