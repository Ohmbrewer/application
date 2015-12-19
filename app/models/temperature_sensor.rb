require 'rhizome_interfaces/sprout/temperature_sensor_sprout'
require 'rhizome_interfaces/validation_sets/onewire_validations'

class TemperatureSensor < Equipment
  include RhizomeInterfaces::TemperatureSensorSprout
  include RhizomeInterfaces::OneWireValidations

  belongs_to :thermostat, validate: true, touch: true
  belongs_to :recirculating_infusion_mash_system, validate: true,
                                                  touch: true,
                                                  foreign_key: :rims_id
  alias_method :rims, :recirculating_infusion_mash_system

  store_accessor :pins, :data_pin, :onewire_index

  validates :onewire_index, presence: true, on: :update
  validates :data_pin, presence: true, on: :update
  validate :index_in_use_validation

  def destroy_disabled?
    !thermostat.nil? ||
    !recirculating_infusion_mash_system.nil? ||
    (!thermostat.nil? && !thermostat.recirculating_infusion_mash_system.nil?)
  end

end
