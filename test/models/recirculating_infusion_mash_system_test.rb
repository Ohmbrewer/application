require 'test_helper'

class RecirculatingInfusionMashSystemTest < ActiveSupport::TestCase
  def setup
    @good_rims = recirculating_infusion_mash_systems(:good_rims)
  end

  test 'should recognize no rhizome attached' do
    assert @good_rims.rhizome.nil?
  end

  test 'should duplicate' do
    duplicate_rims = @good_rims.deep_dup

    assert_equal @good_rims.tube.sensor.pins, duplicate_rims.tube.sensor.pins
    assert_equal @good_rims.tube.element.pins, duplicate_rims.tube.element.pins

    assert_equal @good_rims.safety_sensor.pins, duplicate_rims.safety_sensor.pins
    assert_equal @good_rims.recirculation_pump.pins, duplicate_rims.recirculation_pump.pins
  end
end
