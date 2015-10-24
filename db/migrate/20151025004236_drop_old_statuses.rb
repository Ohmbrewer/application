class DropOldStatuses < ActiveRecord::Migration
  def change
    drop_table :temperature_sensor_statuses
    drop_table :heating_element_statuses
    drop_table :pump_statuses
  end
end
