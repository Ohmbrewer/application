class AddEquipmentProfilesToSchedule < ActiveRecord::Migration
  def change

    create_table :schedule_profiles do |t|
      t.belongs_to :schedule, index: true
      t.belongs_to :equipment_profile, index: true
    end

  end
end
