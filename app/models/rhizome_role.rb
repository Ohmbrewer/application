class RhizomeRole < ActiveRecord::Base

  belongs_to :batch
  belongs_to :role, class_name: 'EquipmentProfile'
  belongs_to :rhizome

end