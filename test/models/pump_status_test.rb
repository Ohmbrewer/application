require 'test_helper'

class PumpStatusTest < ActiveSupport::TestCase
  def setup; end

  test 'should be valid' do
    pump_status = equipment_statuses(:good_pump_on)
    assert pump_status.valid?
  end

  test 'should have PumpStatus equipment class' do
    pump_status = equipment_statuses(:good_pump_on)
    assert_not pump_status.is_basic_equipment_status?
    assert PumpStatus::equipment_class, 'PumpStatus'
  end
end
