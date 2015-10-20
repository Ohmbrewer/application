class CreateThermostats < ActiveRecord::Migration
  def change
    create_table :thermostats do |t|
      t.timestamps null: false
    end

    add_reference :equipments, :thermostat, index: true
  end
end
