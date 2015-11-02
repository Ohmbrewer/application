require 'rhizome_interfaces/sprout/temperature_sensor_sprout'

class TemperatureSensor < Equipment
  include RhizomeInterfaces::TemperatureSensorSprout

  belongs_to :thermostat, validate: true, touch: true
  belongs_to :recirculating_infusion_mash_system, validate: true,
                                                  touch: true,
                                                  foreign_key: :rims_id
  alias_method :rims, :recirculating_infusion_mash_system

  store_accessor :pins, :data_pin, :onewire_id

  validates :onewire_id, presence: true, on: :update
  validates :data_pin, presence: true, on: :update

  def destroy_disabled?
    !thermostat.nil? ||
    !recirculating_infusion_mash_system.nil? ||
    (!thermostat.nil? && !thermostat.recirculating_infusion_mash_system.nil?)
  end

end
