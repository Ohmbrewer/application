require 'test_helper'

class EquipmentTest < ActiveSupport::TestCase
  def setup
    @eqp = equipments(:heating_element_1pin)
    @eqp_two = equipments(:temperature_sensor_3)
  end

  test 'should be valid' do
    assert @eqp.valid?
  end

  test 'should recognize not basic equipment' do
    assert_not @eqp.is_basic_equipment?
  end

  test 'should recognize no rhizome attached' do
    assert_not @eqp.attached?
  end
end
