require 'test_helper'

class TurnOffTaskTest < ActiveSupport::TestCase
  def setup; end

  test 'should hold' do
    task = tasks(:turn_off_no_rims_therm_sensor)
    assert task.holds?
  end

  test 'should start off' do
    assert_raise ArgumentError do
      TurnOffTask.new tasks(:turn_off_no_rims_therm_sensor).attributes.merge(state: 'ON')
    end

    task = TurnOffTask.new tasks(:turn_off_no_rims_therm_sensor).attributes

    assert task.off?
    assert_not task.on?
  end

  test 'should stay off' do
    task = tasks(:turn_off_single_pump)

    assert_raise ArgumentError do
      task.state = 'ON'
    end

    assert task.off?
    assert_not task.on?
  end
end
