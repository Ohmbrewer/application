class CreatePumpStatuses < ActiveRecord::Migration
  def change
    create_table :pump_statuses do |t|
      t.string :device_id
      t.integer :pump_id
      t.string :state
      t.datetime :stop_time
      t.integer :speed

      t.timestamps null: false
    end
  end
end
