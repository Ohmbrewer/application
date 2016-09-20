require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  def setup
    @small_schedule = schedules(:small_schedule)
    Task.rebuild!
  end

  test 'should duplicate' do
    duplicate_schedule = @small_schedule.deep_dup
    duplicate_schedule.save(validate: false)
    duplicate_schedule.reload
    duplicate_schedule.auto_assign_root

    assert_equal "#{@small_schedule.name} (Copy)", duplicate_schedule.name

    @small_schedule.root_task.self_and_descendants.each_with_index do |task, i|
      assert_equal task.type, duplicate_schedule.tasks[i].type
      assert_equal task.update_data, duplicate_schedule.tasks[i].update_data
      assert_equal task.trigger, duplicate_schedule.tasks[i].trigger
      assert_equal task.duration, duplicate_schedule.tasks[i].duration
      assert_equal task.ramp_estimate, duplicate_schedule.tasks[i].ramp_estimate
      assert_equal task.thermostat, duplicate_schedule.tasks[i].thermostat
      assert_equal task.recirculating_infusion_mash_system,
                   duplicate_schedule.tasks[i].recirculating_infusion_mash_system

      expected_pi = @small_schedule.root_task.self_and_descendants.find_index { |a| a == task.parent }
      actual_pi = duplicate_schedule.root_task.self_and_descendants.find_index do |a|
        a == duplicate_schedule.tasks[i].parent
      end
      assert_equal expected_pi, actual_pi
    end
  end
end
