class AddParticleToRhizome < ActiveRecord::Migration
  def change
    add_reference :rhizomes, :particle, index: true
    add_foreign_key :rhizomes, :particles

    add_reference :particles, :rhizome, index: true
    add_foreign_key :particles, :rhizomes
  end
end
