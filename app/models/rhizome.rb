class Rhizome < ActiveRecord::Base

  # == Each Rhizome has a one-to-one relationship with a Particle. ==
  # This sets up that relationship and makes it so we can pass Particle attribute changes through the
  # Rhizome's controller rather than building a full, separate controller just for the associated Particle.
  has_one :particle_device, inverse_of: :rhizome,
                            dependent: :destroy

  has_many :sprouts, dependent: :destroy
  has_many :equipments, -> { distinct },
                        through: :sprouts,
                        source: :sproutable,
                        source_type: 'Equipment'
  delegate :pumps, :heating_elements, :temperature_sensors,
           to: :equipments
  has_many :thermostats, -> { distinct },
           through: :sprouts,
           source: :sproutable,
           source_type: 'Thermostat',
           after_add: :add_thermostat_children
  has_many :recirculating_infusion_mash_systems, -> { distinct },
           through: :sprouts,
           source: :sproutable,
           source_type: 'RecirculatingInfusionMashSystem',
           after_add: :add_rims_children

  accepts_nested_attributes_for :particle_device, update_only: true

  validates :name, presence: true,
                   length: { maximum: 50 }

  # == Instance Methods ==

  # == Sproutable Management Methods ==

  # Provides a short-hand method for getting the various polymorphic
  # equipment types connected to the Rhizome. Add the collection call
  # when you add a new type.
  def attached
    [equipments, thermostats, recirculating_infusion_mash_systems].flatten
  end

  # Associates the subsystems of the given Thermostat as Equipment of the Rhizome
  # @param therm [Thermostat] The Thermostat
  def add_thermostat_children(therm)
    if therm.is_a? Thermostat
      equipments << therm.element
      equipments << therm.sensor
    end
  end

  # Associates the subsystems of the given RIMS as Equipment of the Rhizome
  # @param rims [RecirculatingInfusionMashSystem] The RIMS
  def add_rims_children(rims)
    if rims.is_a? RecirculatingInfusionMashSystem
      add_thermostat_children(rims.tube)
      equipments << rims.safety_sensor
      equipments << rims.recirculation_pump
    end
  end

  # == Particle Device Shortcuts ==

  # Is the Rhizome's Particle device connected to the cloud?
  # @return [TrueFalse] True if the device is connected, false otherwise
  def connected?
    particle_device.connection.connected?
  end

  # A shortcut to the interesting part of the Rhizome's internal ParticleDevice object
  # @return [Particle::Client] The client for interacting with the Particle device
  def particle
    particle_device.connection
  end

  # == Class Methods ==
  class << self

    # The digital pins supported by the Rhizome.
    def digital_pins
      [0, 1, 2, 3, 4, 5]
    end

    def from_device_id(device_id)
      pd = ParticleDevice.where(device_id: device_id).first
      Rhizome.find(pd.rhizome.id)
    end

    # Provides a standardized option list of all the Tasks
    # @return [Array] An option list array
    def rhizome_options
      all.collect do |r|
        [
          r.name,
          (r.temperature_sensors.order('id ASC') +
           r.heating_elements.order('id ASC') +
           r.pumps.order('id ASC') +
           r.thermostats.order('id ASC') +
           r.recirculating_infusion_mash_systems.order('id ASC')).collect do |s|
            ["#{s.type.titlecase} #{s.rhizome_eid}", "#{s.type}_#{s.id}"]
          end
        ]
      end
    end

  end

end
