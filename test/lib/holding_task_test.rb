require 'test_helper'

class HoldingTaskTest < ActiveSupport::TestCase
  def setup; end

  test 'should be 0% complete if not started' do
    task = tasks(:turn_off_no_rims_therm_sensor)
    assert_equal 0, task.percent_complete
  end

  test 'should be less than 100% complete if started but not done' do
    task = tasks(:turn_off_no_rims_therm_sensor)
    task.start_time = Time.now.to_i
    task.duration = 60
    task.status = :holding
    assert_in_delta (Time.now.to_i - task.start_time) / task.duration, task.percent_complete
  end

  test 'should be 100% complete if done' do
    task = tasks(:turn_off_no_rims_therm_sensor)
    task.status = :done
    assert_equal 100, task.percent_complete
  end
end
