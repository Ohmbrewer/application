class AddRampEstimateToTask < ActiveRecord::Migration
  def change
    change_table :tasks do |t|

      t.integer :ramp_estimate, default: 0

    end
  end
end
