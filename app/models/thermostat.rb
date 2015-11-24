require 'rhizome_interfaces/sprout/thermostat_sprout'

class Thermostat < ActiveRecord::Base
  include RhizomeInterfaces::ThermostatSprout

  has_one :sprout, as: :sproutable, dependent: :destroy
  has_one :equipment_profile, through: :sprout

  has_one :element, class_name: 'HeatingElement',
                    validate: true,
                    dependent: :destroy
  has_one :sensor, class_name: 'TemperatureSensor',
                   validate: true,
                   dependent: :destroy

  belongs_to :recirculating_infusion_mash_system, validate: true,
                                                  touch: true,
                                                  inverse_of: :tube,
                                                  foreign_key: :rims_id
  alias_attribute :rims, :recirculating_infusion_mash_system

  accepts_nested_attributes_for :element, update_only: true
  accepts_nested_attributes_for :sensor, update_only: true

  # == Validations ==
  validate :ep_must_match_validation
  validates :element, presence: true
  validates :sensor, presence: true

  def ep_must_match_validation
    unless equipment_profile.nil?
      unless element.nil? || sensor.nil?
        unless element.equipment_profile.nil? || sensor.equipment_profile.nil?
          unless element.equipment_profile == sensor.equipment_profile
            errors.add(:element, ' and Sensor must be registered as attached to the same Equipment Profile.')
          end
        end
      end
    end
  end

  # The Rhizome the Equipment is currently attached to, if any.
  # @return [Rhizome] The Rhizome the Equipment is currently attached to, if any.
  def rhizome
    equipment_profile.current_rhizome
  end

  def equipment_profile=(ep)
    super
    element.equipment_profile = ep unless element.nil?
    sensor.equipment_profile = ep unless sensor.nil?
  end

  def type
    'Thermostat'
  end

  def build_subsystems
    build_element
    build_sensor
  end

  def destroy_disabled?
    !rims.nil?
  end

  def deep_dup
    new_thermostat = super
    new_thermostat.sensor = sensor.deep_dup
    new_thermostat.element = element.deep_dup
    new_thermostat
  end

end
