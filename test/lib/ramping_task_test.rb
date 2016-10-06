require 'test_helper'

class RampingTaskTest < ActiveSupport::TestCase
  def setup; end

  test 'should be 0% ramping complete if not started' do
    task = tasks(:run_thermostat_without_rims)
    assert_equal 0, task.percent_ramp_complete
  end

  test 'should be less than 100% ramping complete if started but not done ramping' do
    task = tasks(:run_thermostat_without_rims)
    task.ramp_start_time = Time.now.to_i
    task.ramp_estimate = 60
    task.status = :ramping
    assert_in_delta (Time.now.to_i - task.ramp_start_time) / task.ramp_estimate, task.percent_ramp_complete
  end

  test 'should be 100% ramp complete if done ramping' do
    task = tasks(:run_thermostat_without_rims)
    task.start_time = Time.now.to_i
    task.status = :holding
    assert_equal 100, task.percent_ramp_complete
  end

  test 'should be 0% complete if not started' do
    task = tasks(:run_thermostat_without_rims)
    assert_equal 0, task.percent_complete
  end

  test 'should be less than 100% complete if started but not done' do
    task = tasks(:run_thermostat_without_rims)
    task.start_time = Time.now.to_i
    task.duration = 60
    task.ramp_start_time = Time.now.to_i
    task.hold_start_time = Time.now.to_i
    task.status = :holding
    assert_in_delta (Time.now.to_i - task.start_time) / task.duration, task.percent_complete
  end

  test 'should be 100% complete if done' do
    task = tasks(:run_thermostat_without_rims)
    task.status = :done
    assert_equal 100, task.percent_complete
  end
end
