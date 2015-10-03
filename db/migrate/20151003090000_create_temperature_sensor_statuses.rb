class CreateTemperatureSensorStatuses < ActiveRecord::Migration
  def change
    create_table :temperature_sensor_statuses do |t|
      t.string :device_id
      t.integer :temp_id
      t.string :state
      t.datetime :stop_time
      t.float :temperature
      t.datetime :last_read_time

      t.timestamps null: false
    end
  end
end
