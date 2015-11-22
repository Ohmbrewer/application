class AddThermostatToTask < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.belongs_to :thermostat
    end
  end
end
