class CreateHeatingElementStatuses < ActiveRecord::Migration
  def change
    create_table :heating_element_statuses do |t|
      t.string :device_id
      t.integer :heat_id
      t.string :state
      t.datetime :stop_time
      t.integer :voltage

      t.timestamps null: false
    end
  end
end
