require 'test_helper'

class TurnOnTaskTest < ActiveSupport::TestCase
  def setup; end

  test 'should hold' do
    task = tasks(:turn_on_no_rims_therm_sensor)
    assert task.holds?
  end

  test 'should start on' do
    task = TurnOnTask.new tasks(:turn_on_no_rims_therm_sensor).attributes.merge(state: 'OFF')
    assert task.on?
    assert_not task.off?
  end

  test 'should stay on' do
    task = tasks(:turn_on_no_rims_therm_sensor)
    task.state = 'OFF'
    assert task.on?
    assert_not task.off?
  end
end
