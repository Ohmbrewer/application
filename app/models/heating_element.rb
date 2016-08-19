require 'rhizome_interfaces/sprout/heating_element_sprout'
require 'rhizome_interfaces/validation_sets/relay_validations'

class HeatingElement < Equipment
  include RhizomeInterfaces::HeatingElementSprout
  include RhizomeInterfaces::RelayValidations

  belongs_to :thermostat,
             validate: true,
             touch: true,
             inverse_of: :element

  store_accessor :pins, :control_pin, :power_pin, :voltage

  validate :pin_match_validation
  validate :control_pin_in_use_validation
  validate :power_pin_in_use_validation
  validates :control_pin, presence: true

  def destroy_disabled?
    !thermostat.nil? ||
    (!thermostat.nil? && !thermostat.rims.nil?)
  end

end
