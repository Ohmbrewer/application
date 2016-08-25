require 'test_helper'

class RunThermostatTaskTest < ActiveSupport::TestCase
  def setup; end

  test 'should be valid' do
    task = tasks(:run_thermostat_invalid)
    assert_not task.valid?
  end

  test 'should have thermostat sprout' do
    task = tasks(:run_thermostat_without_rims)
    assert_equal task.sprout, task.thermostat
  end

  test 'should hold' do
    task = tasks(:run_thermostat_without_rims)
    assert task.holds?
  end

  test 'should ramp' do
    task = tasks(:run_thermostat_without_rims)
    assert task.ramps?
  end

  test 'should have target temperature' do
    task = tasks(:run_thermostat_without_rims)
    assert task.target_temperature, '100'
  end

  test 'should convert to particle args' do
    task = tasks(:run_thermostat_without_rims)
    expected_hash = {
      current_task: task.id,
      state: task.state,
      stop_time: task.stop_time,
      target: task.target_temperature.to_f
    }
    assert_equal task.to_particle_args, expected_hash
  end
end
