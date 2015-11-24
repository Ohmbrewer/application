class CreateEquipmentProfiles < ActiveRecord::Migration
  def change
    create_table :equipment_profiles do |t|
      t.string :name, null: false, unique: true

      t.timestamps null: false
    end

    add_reference :sprouts, :equipment_profile, index: true
  end
end
