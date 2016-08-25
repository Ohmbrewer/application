require 'test_helper'

class EquipmentStatusTest < ActiveSupport::TestCase
  def setup; end

  test 'should recognize valid EquipmentStatus types' do
    assert_equal EquipmentStatus::equipment_status_types, %w(PumpStatus HeatingElementStatus TemperatureSensorStatus)
  end

  test 'should convert unknown status' do
    assert EquipmentStatus::convert_state('--'), :unknown
  end

  test 'should convert on status' do
    assert EquipmentStatus::convert_state('ON'), :on
  end

  test 'should convert off status' do
    assert EquipmentStatus::convert_state('OFF'), :off
  end

  test 'should convert epoch time' do
    right_now = Time.now
    assert EquipmentStatus::convert_time(right_now.to_i), right_now.to_datetime
  end
end
