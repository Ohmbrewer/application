class CreateRhizomeRoles < ActiveRecord::Migration
  def change
    create_table :rhizome_roles do |t|
      t.belongs_to :batch
      t.belongs_to :role
      t.belongs_to :rhizome
    end

    remove_reference :sprouts, :rhizome
  end
end
