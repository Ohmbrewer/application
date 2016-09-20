class EquipmentProfile < ActiveRecord::Base
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
  has_many :schedule_profiles, dependent: :destroy
  has_many :schedules, through: :schedule_profiles

  validates :name,
            presence: true,
            length: { maximum: 50 }

  # == Instance Methods ==

  # == Sproutable Management Methods ==

  # Provides a short-hand method for getting the various polymorphic
  # equipment types connected to the Rhizome. Add the collection call
  # when you add a new type.
  def attached
    [equipments, thermostats, recirculating_infusion_mash_systems].flatten
  end

  def non_component_equipment
    equipments.non_components
  end

  def non_component_temperature_sensors
    temperature_sensors.non_components
  end

  def non_component_heating_elements
    heating_elements.non_components
  end

  def non_component_pumps
    pumps.non_components
  end

  def non_component_thermostats
    thermostats.non_components
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

  def deep_dup
    new_equipment_profile = super
    new_equipment_profile.name = "#{new_equipment_profile.name} (Copy)"

    # Now, carefully duplicate the attached RIMS...
    recirculating_infusion_mash_systems.each do |rims|
      new_rims = rims.deep_dup
      new_rims.equipment_profile = new_equipment_profile
      new_equipment_profile.recirculating_infusion_mash_systems << new_rims
    end

    # Now, carefully duplicate the attached Thermostats...
    thermostats.each do |thermostat|
      next unless thermostat.recirculating_infusion_mash_system.nil?

      new_thermostat = thermostat.deep_dup
      new_thermostat.equipment_profile = new_equipment_profile
      new_equipment_profile.thermostats << new_thermostat
    end

    # Now, carefully duplicate the remaining attached Equipment...
    equipments.each do |equipment|
      next unless equipment.rims_id.nil? && equipment.thermostat_id.nil?

      new_equipment = equipment.deep_dup
      new_equipment.equipment_profile = new_equipment_profile
      new_equipment_profile.equipments << new_equipment
    end

    new_equipment_profile
  end

  # The Rhizome that is currently using this Equipment Profile
  # @return [Rhizome] The Rhizome using this Equipment Profile, if any
  def current_rhizome
    RhizomeRole.joins(:rhizome)
               .where('rhizomes.batch_id = rhizome_roles.batch_id')
               .find_by(role: id)
               .try(:rhizome)
  end

  # == Class Methods ==
  class << self
    # The digital pins supported by the Rhizome.
    def digital_pins
      [0, 1, 2, 3, 4, 5]
    end

    # Provides a standardized option list of all the Tasks
    # @return [Array] An option list array
    def equipment_profile_options
      all.collect do |ep|
        [
          ep.name,
          (ep.temperature_sensors.order('id ASC') +
              ep.heating_elements.order('id ASC') +
              ep.pumps.order('id ASC') +
              ep.thermostats.order('id ASC') +
              ep.recirculating_infusion_mash_systems.order('id ASC')).collect do |s|
            ["#{s.type.titlecase} #{s.rhizome_eid}", "#{s.type}_#{s.id}"]
          end
        ]
      end
    end
  end
end
