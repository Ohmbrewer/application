require 'rhizome_interfaces/sprout/pump_sprout'
require 'rhizome_interfaces/validation_sets/relay_validations'

class Pump < Equipment
  include RhizomeInterfaces::PumpSprout
  include RhizomeInterfaces::RelayValidations

  has_many :pump_statuses,
           foreign_key: :equipment_id
  belongs_to :recirculating_infusion_mash_system,
             validate: true,
             touch: true,
             inverse_of: :recirculation_pump,
             foreign_key: :rims_id
  alias_attribute :rims, :recirculating_infusion_mash_system

  store_accessor :pins, :control_pin

  validates :control_pin, presence: true
  validate :control_pin_in_use_validation

  def destroy_disabled?
    !rims.nil?
  end

end
