require 'test_helper'

class TurnOnTaskTest < ActiveSupport::TestCase
  def setup; end

  test 'should hold' do
    task = tasks(:turn_on_no_rims_therm_sensor)
    assert task.holds?
  end

  test 'should start on' do
    assert_raise ArgumentError do
      TurnOnTask.new tasks(:turn_on_no_rims_therm_sensor).attributes.merge(state: 'OFF')
    end

    task = TurnOnTask.new tasks(:turn_on_no_rims_therm_sensor).attributes

    assert task.on?
    assert_not task.off?
  end

  test 'should stay on' do
    task = tasks(:turn_on_no_rims_therm_sensor)

    assert_raise ArgumentError do
      task.state = 'OFF'
    end

    assert task.on?
    assert_not task.off?
  end
end
