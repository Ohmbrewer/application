require 'test_helper'

class TurnOffTaskTest < ActiveSupport::TestCase
  def setup; end

  test 'should hold' do
    task = tasks(:turn_off_no_rims_therm_sensor)
    assert task.holds?
  end

  test 'should start off' do
    task = TurnOffTask.new tasks(:turn_off_no_rims_therm_sensor).attributes.merge(state: 'ON')
    assert task.off?
    assert_not task.on?
  end

  test 'should stay off' do
    task = tasks(:turn_off_single_pump)
    task.state = 'ON'
    assert task.off?
    assert_not task.on?
  end
end
