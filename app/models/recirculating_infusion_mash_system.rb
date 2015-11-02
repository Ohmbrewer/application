require 'rhizome_interfaces/sprout/rims_sprout'

class RecirculatingInfusionMashSystem < ActiveRecord::Base
  include RhizomeInterfaces::RIMSSprout

  has_one :sprout, as: :sproutable, dependent: :destroy
  has_one :rhizome, through: :sprout

  has_one :tube, class_name: 'Thermostat',
          validate: true,
          dependent: :destroy,
          foreign_key: :rims_id,
          inverse_of: :recirculating_infusion_mash_system
  has_one :safety_sensor, class_name: 'TemperatureSensor',
          validate: true,
          dependent: :destroy,
          foreign_key: :rims_id
  has_one :recirculation_pump, class_name: 'Pump',
          validate: true,
          dependent: :destroy,
          foreign_key: :rims_id

  accepts_nested_attributes_for :tube, update_only: true
  accepts_nested_attributes_for :safety_sensor, update_only: true
  accepts_nested_attributes_for :recirculation_pump, update_only: true

  validate :rhizome_must_match_validation
  validates :tube, presence: true
  validates :safety_sensor, presence: true
  validates :recirculation_pump, presence: true

  def rhizome_must_match_validation
    unless tube.nil? || safety_sensor.nil? || recirculation_pump.nil?
      unless tube.rhizome.nil? || safety_sensor.rhizome.nil? || recirculation_pump.rhizome.nil?
        unless (tube.rhizome == safety_sensor.rhizome) && (tube.rhizome == recirculation_pump.rhizome)
          errors.add(:tube, ', Safety Sensor, and Recirculation Pump must be registered as attached to the same Rhizome.')
        end
      end
    end
  end

  def rhizome=(r)
    super
    tube.rhizome = r unless tube.nil?
    safety_sensor.rhizome = r unless safety_sensor.nil?
    recirculation_pump.rhizome = r unless recirculation_pump.nil?
  end

  def thermostat=(t)
    super
    tube.sensor.recirculating_infusion_mash_system = t.recirculating_infusion_mash_system unless tube.sensor.nil?
    tube.element.recirculating_infusion_mash_system = t.recirculating_infusion_mash_system unless tube.element.nil?
  end

  def type
    'RIMS'
  end

  def build_subsystems
    build_tube
    tube.build_subsystems
    build_safety_sensor
    build_recirculation_pump
  end

end
