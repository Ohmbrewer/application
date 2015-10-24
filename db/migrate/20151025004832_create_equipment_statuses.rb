class CreateEquipmentStatuses < ActiveRecord::Migration
  def change

    # Equipment is an STI base class, so we need to provide a type.
    # Each subclass has varying amounts of data, so we'll use a JSONB column for flexibility.
    create_table :equipment_statuses do |t|
      t.belongs_to :equipment, index: true
      t.string     :type
      t.integer    :state
      t.datetime   :stop_time
      t.jsonb      :data, default: '{}', index: true, using: :gin
      t.timestamps null: false
    end

  end
end
