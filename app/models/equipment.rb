class Equipment < ActiveRecord::Base

  has_one :sprout, as: :sproutable, dependent: :destroy
  has_one :rhizome, through: :sprout

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

  def attached?
    rhizome.nil?
  end

  def is_basic_equipment?
    type == 'Equipment'
  end

  class << self

    # TODO: Move this out into a table of available Equipment Types
    # The list of supported Equipment types
    def equipment_types
      %w(Pump HeatingElement TemperatureSensor)
    end

  end

end
