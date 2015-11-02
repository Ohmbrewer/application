class FixParticleDeviceFk < ActiveRecord::Migration
  def change
    remove_column :rhizomes, 'particle_id', :integer, index: true
  end
end
