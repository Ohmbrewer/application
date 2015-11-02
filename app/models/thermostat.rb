require 'rhizome_interfaces/sprout/thermostat_sprout'

class Thermostat < ActiveRecord::Base
  include RhizomeInterfaces::ThermostatSprout

  has_one :sprout, as: :sproutable, dependent: :destroy
  has_one :rhizome, through: :sprout

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

  validate :rhizome_must_match_validation
  validates :element, presence: true
  validates :sensor, presence: true

  def rhizome_must_match_validation
    unless element.nil? || sensor.nil?
      unless element.rhizome.nil? || sensor.rhizome.nil?
        unless element.rhizome == sensor.rhizome
          errors.add(:element, ' and Sensor must be registered as attached to the same Rhizome.')
        end
      end
    end
  end

  def rhizome=(r)
    super
    element.rhizome = r unless element.nil?
    sensor.rhizome = r unless sensor.nil?
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

end
