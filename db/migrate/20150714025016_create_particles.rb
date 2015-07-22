class CreateParticles < ActiveRecord::Migration
  def change
    create_table :particles do |t|
      t.string :device_id, null: false
      t.string :encrypted_access_token

      t.timestamps null: false
    end
    add_index :particles, :device_id, unique: true
  end
end
