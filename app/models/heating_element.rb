require 'rhizome_sprout/rhizome_sprout'
require 'validation_sets/relay_validations'

class HeatingElement < Equipment
  include RhizomeSprout
  include RelayValidations

  belongs_to :thermostat, validate: true, touch: true
  belongs_to :recirculating_infusion_mash_system, validate: true,
                                                  touch: true,
                                                  foreign_key: :rims_id
  alias_attribute :rims, :recirculating_infusion_mash_system

  store_accessor :pins, :control_pin, :power_pin

  validate :pin_match_validation
  validate :control_pin_in_use_validation
  validate :power_pin_in_use_validation

  # == Sproutable Interface Methods ==
  def rhizome_eid
    control_pin
  end

  def rhizome_type_name
    'heat'
  end

  def destroy_disabled?
    !thermostat.nil? ||
    (!thermostat.nil? && !thermostat.rims.nil?)
  end

end
