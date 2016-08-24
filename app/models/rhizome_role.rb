class RhizomeRole < ActiveRecord::Base
  belongs_to :batch, dependent: :destroy
  belongs_to :role, class_name: 'EquipmentProfile'
  belongs_to :rhizome

  before_destroy :unclaim_rhizomes

  def unclaim_rhizomes
    rhizome.batch_id = nil
    rhizome.save
  end
end
