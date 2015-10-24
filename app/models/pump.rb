require 'rhizome_interfaces/sprout/pump_sprout'
require 'rhizome_interfaces/validation_sets/relay_validations'

class Pump < Equipment
  include RhizomeInterfaces::PumpSprout
  include RhizomeInterfaces::RelayValidations

  belongs_to :recirculating_infusion_mash_system, validate: true,
                                                  touch: true,
                                                  foreign_key: :rims_id
  alias_attribute :rims, :recirculating_infusion_mash_system

  store_accessor :pins, :control_pin, :power_pin, :speed

  validate :pin_match_validation
  validate :control_pin_in_use_validation
  validate :power_pin_in_use_validation

  def destroy_disabled?
    !rims.nil?
  end

end
