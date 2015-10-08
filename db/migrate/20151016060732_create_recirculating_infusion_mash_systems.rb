class CreateRecirculatingInfusionMashSystems < ActiveRecord::Migration
  def change
    create_table :recirculating_infusion_mash_systems do |t|

      t.timestamps null: false
    end

    add_reference :equipments, :rims, index: true
    add_reference :thermostats, :rims, index: true
  end
end
