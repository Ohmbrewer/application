class RemoveSpeedFromPumpStatus < ActiveRecord::Migration
  def change
    remove_column :pump_statuses, :speed, :integer
  end
end
