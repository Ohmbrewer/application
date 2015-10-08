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

  # Provides a short-hand method for getting the various polymorphic
  # equipment types connected to the Rhizome. Add the collection call
  # when you add a new type.
  def attached
    [equipments, thermostats].flatten
  end

  def add_thermostat_children(t)
    if t.is_a? Thermostat
      equipments << t.element
      equipments << t.sensor
    end
  end

  def add_rims_children(t)
    if t.is_a? RecirculatingInfusionMashSystem
      add_thermostat_children(t.tube)
      equipments << t.safety_sensor
      equipments << t.recirculation_pump
    end
  end

  class << self

    # The digital pins supported by the Rhizome.
    def digital_pins
      [0, 1, 2, 3, 4, 5]
    end

  end

end
