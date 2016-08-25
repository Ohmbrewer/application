require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  def setup; end

  test 'should not block' do
    task = tasks(:turn_on_no_rims_therm_sensor)
    assert_not task.blocking?
  end

  test 'should convert to particle args' do
    task = tasks(:turn_on_no_rims_therm_sensor)
    expected_hash = {
      current_task: task.id,
      state: task.state,
      stop_time: task.stop_time
    }
    assert_equal task.to_particle_args, expected_hash
  end
end
