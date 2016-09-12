class Rhizome < ActiveRecord::Base
  # == Each Rhizome has a one-to-one relationship with a Particle. ==
  # This sets up that relationship and makes it so we can pass Particle attribute changes through the
  # Rhizome's controller rather than building a full, separate controller just for the associated Particle.
  has_one :particle_device, inverse_of: :rhizome,
                            dependent: :destroy

  belongs_to :batch, inverse_of: :rhizomes

  has_one :rhizome_role, ->(rhizome) { where(batch: rhizome.batch) }
  has_one :role, through: :rhizome_role
  has_many :sprouts, through: :role

  # Supported Sprouts
  has_many :equipments,
           -> { distinct },
           through: :sprouts,
           source: :sproutable,
           source_type: 'Equipment'
  delegate :pumps, :heating_elements, :temperature_sensors,
           to: :equipments
  has_many :thermostats, -> { distinct },
           through: :sprouts,
           source: :sproutable,
           source_type: 'Thermostat'
  has_many :recirculating_infusion_mash_systems, -> { distinct },
           through: :sprouts,
           source: :sproutable,
           source_type: 'RecirculatingInfusionMashSystem'

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

  # == Particle Device Shortcuts ==

  # Is the Rhizome's Particle device connected to the cloud?
  # @return [TrueFalse] True if the device is connected, false otherwise
  def connected?
    particle.connected?
  end

  # A shortcut to the interesting part of the Rhizome's internal ParticleDevice object
  # @return [Particle::Client] The client for interacting with the Particle device
  def particle
    particle_device.connection
  end

  # == Batch Management Methods ==

  # Whether the Rhizome is currently being used by a Batch
  # @return [TrueFalse] True if the Rhizome is in use
  def in_use?
    !batch.nil?
  end

  # == Class Methods ==
  class << self
    # The digital pins supported by the Rhizome.
    def digital_pins
      [0, 1, 2, 3, 4, 5]
    end

    def from_device_id(device_id)
      pd = ParticleDevice.where(device_id: device_id).first
      Rhizome.find(pd.rhizome.id) unless pd.nil?
    end
  end
end
