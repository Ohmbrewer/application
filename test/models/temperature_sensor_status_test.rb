require 'test_helper'

class TemperatureSensorStatusTest < ActiveSupport::TestCase
  def setup; end

  test 'should be valid' do
    temp_status = equipment_statuses(:no_rims_therm_sensor_on)
    assert temp_status.valid?
  end

  test 'should have TemperatureSensor equipment class' do
    temp_status = equipment_statuses(:no_rims_therm_sensor_on)
    assert_not temp_status.is_basic_equipment_status?
    assert TemperatureSensorStatus::equipment_class, 'TemperatureSensor'
  end
end
