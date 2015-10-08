class CreateEquipments < ActiveRecord::Migration
  def change

    # This is our join table to connect Rhizomes to various forms of Equipment
    create_table :sprouts do |t|
      t.references :rhizome
      t.references :sproutable, polymorphic: true, index: true
    end

    # Equipment is an STI base class, so we need to provide a type.
    # Each subclass has 0+ pins, so we'll use a JSONB column for flexibility.
    create_table :equipments do |t|
      t.string  :type
      t.jsonb   :pins, null: false, default: '{}', index: true, using: :gin
      t.timestamps null: false
    end

  end
end
