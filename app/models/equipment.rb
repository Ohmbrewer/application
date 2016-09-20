class Equipment < ActiveRecord::Base
  has_many :equipment_statuses,
           inverse_of: :equipment
  alias_attribute :statuses, :equipment_statuses

  has_one :sprout,
          as: :sproutable,
          dependent: :destroy
  has_one :equipment_profile,
          through: :sprout
  belongs_to :thermostat,
             touch: true
  belongs_to :recirculating_infusion_mash_system,
             touch: true,
             foreign_key: :rims_id

  # == Subclass scopes ==
  # These scopes make so anything that references Equipment generally
  # may also reference each of these subclasses specifically, automagically.
  scope :pumps, -> { where(type: 'Pump') }
  scope :heating_elements, -> { where(type: 'HeatingElement') }
  scope :temperature_sensors, -> { where(type: 'TemperatureSensor') }

  # == Serializers ==
  # HashSerializer provides a way to convert the JSONB contents
  # of the :pins column into a Hash object
  serialize :pins, HashSerializer

  # == Validations ==
  validates :equipment_profile, presence: true

  # == Instance Methods ==

  # The Rhizome the Equipment is currently attached to, if any.
  # @return [Rhizome] The Rhizome the Equipment is currently attached to, if any.
  def rhizome
    equipment_profile.nil? || equipment_profile.current_rhizome
  end

  def attached?
    rhizome.nil?
  end

  def component?
    !thermostat.nil? || !recirculating_infusion_mash_system.nil?
  end

  def non_component?
    !component?
  end

  def basic_equipment?
    type == 'Equipment'
  end

  class << self
    # TODO: Move this out into a table of available Equipment Types
    # The list of supported Equipment types
    def equipment_types
      %w(Pump HeatingElement TemperatureSensor)
    end

    def components
      all.select(&:component?)
    end

    def non_components
      all.select(&:non_component?)
    end
  end
end
