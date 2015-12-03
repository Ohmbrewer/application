require 'test_helper'

class EquipmentTest < ActiveSupport::TestCase
  def setup

    @eqp = equipments(:equipments_001)
    @eqp_two = equipments(:equipments_003)

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
