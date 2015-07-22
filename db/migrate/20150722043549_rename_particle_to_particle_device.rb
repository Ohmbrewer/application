class RenameParticleToParticleDevice < ActiveRecord::Migration
  def change
    rename_table :particles, :particle_devices
  end
end
