require 'test_helper'

class HeatingElementStatusTest < ActiveSupport::TestCase
  def setup; end

  test 'should be valid' do
    heat_status = equipment_statuses(:heating_element_2pin_on)
    assert heat_status.valid?
  end

  test 'should have HeatingElement equipment class' do
    heat_status = equipment_statuses(:heating_element_2pin_on)
    assert_not heat_status.is_basic_equipment_status?
    assert HeatingElementStatus::equipment_class, 'HeatingElement'
  end
end
