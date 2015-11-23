class AddRimsToTask < ActiveRecord::Migration
  def change
    change_table :tasks do |t|
      t.belongs_to :recirculating_infusion_mash_system
    end
  end
end
