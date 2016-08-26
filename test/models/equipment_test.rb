require 'test_helper'

class EquipmentTest < ActiveSupport::TestCase
  def setup
    @eqp = equipments(:heating_element_1pin)
    @eqp.sprout = sprouts(:ep1_to_heating_element_1pin)
  end

  test 'should be valid' do
    assert @eqp.valid?
  end

  test 'should have thermostat' do
    temp_sensor = equipments(:good_rims_therm_sensor)
    assert_not temp_sensor.thermostat.nil?
  end

  test 'should not have thermostat' do
    pump = equipments(:good_pump)
    assert pump.thermostat.nil?
  end

  test 'should have rims' do
    temp_sensor = equipments(:good_rims_therm_sensor)
    assert_not temp_sensor.thermostat.nil?
  end

  test 'should not have rims' do
    pump = equipments(:single_pump)
    assert pump.thermostat.nil?
  end

  test 'should recognize not basic equipment' do
    assert_not @eqp.basic_equipment?
  end

  test 'should recognize no rhizome attached' do
    single_pump = equipments(:single_pump)
    assert_not single_pump.attached?
  end

  test 'should have data pin if TemperatureSensor' do
    bad_temp_sensor = equipments(:bad_sensor_no_pin)
    assert_not bad_temp_sensor.valid?
  end

  test 'should have onewire index if TemperatureSensor' do
    bad_temp_sensor = equipments(:bad_sensor_no_index)
    assert_not bad_temp_sensor.valid?
  end

  test 'should have control pin if Pump' do
    bad_pump = equipments(:bad_pump)
    assert_not bad_pump.valid?
  end

  test 'should have control pin if HeatingElement' do
    bad_heating_element = equipments(:bad_heating_element)
    assert_not bad_heating_element.valid?
  end
end
