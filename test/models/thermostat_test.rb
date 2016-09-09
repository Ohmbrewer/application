require 'test_helper'

class ThermostatTest < ActiveSupport::TestCase
  def setup
    @without_rims = thermostats(:without_rims)
    @with_rims = thermostats(:with_rims)
  end

  test 'should be valid with rims' do
    assert @with_rims.valid?
  end

  test 'should be valid without rims' do
    assert @without_rims.valid?
  end

  test 'should recognize no rhizome attached' do
    assert @without_rims.rhizome.nil?
  end

  test 'should duplicate' do
    duplicate_therm = @without_rims.deep_dup

    assert_equal @without_rims.sensor.pins, duplicate_therm.sensor.pins
    assert_equal @without_rims.element.pins, duplicate_therm.element.pins
  end
end
