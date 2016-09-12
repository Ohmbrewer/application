require 'rhizome_interfaces/sprout/temperature_sensor_sprout'
require 'rhizome_interfaces/validation_sets/onewire_validations'

class TemperatureSensor < Equipment
  include RhizomeInterfaces::TemperatureSensorSprout
  include RhizomeInterfaces::OneWireValidations

  has_many :temperature_sensor_statuses,
           foreign_key: :equipment_id
  belongs_to :thermostat,
             validate: true,
             touch: true,
             inverse_of: :sensor
  belongs_to :recirculating_infusion_mash_system,
             validate: true,
             touch: true,
             inverse_of: :safety_sensor,
             foreign_key: :rims_id
  alias_method :rims, :recirculating_infusion_mash_system

  store_accessor :pins, :data_pin, :onewire_index

  validates :onewire_index, presence: true, on: :update
  validates :data_pin, presence: true, on: :update
  validate :index_in_use_validation

  def destroy_disabled?
    !thermostat.nil? ||
    !recirculating_infusion_mash_system.nil? ||
    (!thermostat.nil? && !thermostat.recirculating_infusion_mash_system.nil?)
  end

  # Provides a datatable representing the TemperatureSensor for use with a Google Chart Gauge chart
  # @return [GoogleVisualr::DataTable] The datatable
  def to_gauge_data
    chart_data = GoogleVisualr::DataTable.new
    chart_data.new_column('string', 'Label')
    chart_data.new_column('number', 'Value')

    row =
      if temperature_sensor_statuses.length.zero?
        [
          'NO DATA', 0
        ]
      else
        [
          temperature_sensor_statuses.last.state,
          temperature_sensor_statuses.last.temperature
        ]
      end
    chart_data.add_row(row)

    chart_data
  end

  # Provides a Google Chart object that can be inserted into the page
  # @param [Hash] options Override of default options passed to the chart
  # @return [GoogleVisualr::Interactive::Gauge] The Gauge chart
  def to_gauge(options = {})
    data = self.to_gauge_data
    options = {
      minorTicks: 5,
      version: 'current'
    }.merge!(options)
    GoogleVisualr::Interactive::Gauge.new(data, options)
  end
end
