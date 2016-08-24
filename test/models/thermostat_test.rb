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
end
