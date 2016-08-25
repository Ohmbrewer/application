require 'rhizome_interfaces/sprout/rims_sprout'

class RecirculatingInfusionMashSystem < ActiveRecord::Base
  include RhizomeInterfaces::RIMSSprout

  has_one :sprout, as: :sproutable, dependent: :destroy
  has_one :equipment_profile, through: :sprout

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

  validate :ep_must_match_validation
  validates :tube, presence: true
  validates :safety_sensor, presence: true
  validates :recirculation_pump, presence: true

  def ep_must_match_validation
    unless equipment_profile.nil?
      unless tube.nil? && safety_sensor.nil? && recirculation_pump.nil?
        if (tube.equipment_profile.nil? || safety_sensor.equipment_profile.nil? || recirculation_pump.equipment_profile.nil?) ||
            !((tube.equipment_profile == safety_sensor.equipment_profile) && (tube.equipment_profile == recirculation_pump.equipment_profile))
          errors.add(:tube, ', Safety Sensor, and Recirculation Pump must be registered as attached to the same Equipment Profile.')
        end
      end
    end
  end

  # The Rhizome the Equipment is currently attached to, if any.
  # @return [Rhizome] The Rhizome the Equipment is currently attached to, if any.
  def rhizome
    equipment_profile.nil? ? nil : equipment_profile.current_rhizome
  end

  def equipment_profile=(ep)
    super
    tube.equipment_profile = ep unless tube.nil?
    safety_sensor.equipment_profile = ep unless safety_sensor.nil?
    recirculation_pump.equipment_profile = ep unless recirculation_pump.nil?
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

  def deep_dup
    new_rims = super
    new_rims.tube = tube.deep_dup
    new_rims.safety_sensor = safety_sensor.deep_dup
    new_rims.recirculation_pump = recirculation_pump.deep_dup
    new_rims
  end

end
