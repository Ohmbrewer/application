module Util
  class BrewingCalculators
    class << self

      def strike_temperature(temp_current, temp_target, lbs_grain, vol_add)
        #specify vol type
        ((.2/(vol_add/lbs_grain))*(temp_target-temp_current)+temp_target)
      end

      def mash_temperature(temp_current, temp_target, lbs_grain, vol_add, vol_current)
        #specify vol type
        ((temp_target-temp_current)*(.2*lbs_grain+vol_current)/vol_add)+temp_target
      end

      def ibu(percent_aa, oz_add, sg_batch, time_boil, vol_batch)
        #volume....gallons?
        (((percent_aa*oz_add)*(1.65*(.000125**(sg_batch-1.0)))*((1-Math.E**(-.04*time_boil))/4.15)*75)/vol_batch)
      end

    end
  end
end
