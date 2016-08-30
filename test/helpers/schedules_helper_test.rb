require 'test_helper'

class SchedulesHelperTest < ActionView::TestCase
  def setup; end

  test 'creates a successful multiple delete message' do
    assert_equal 'Schedules deleted!', delete_multiple_schedules_success_message
  end

  test 'creates an unsuccessful multiple delete message' do
    assert_equal 'Schedules were not deleted!', delete_multiple_schedules_fail_message
  end

  test 'creates a somewhat successful multiple delete message' do
    assert_equal "Something strange happened... 1 Schedules weren't deleted.",
                 delete_multiple_schedules_mix_message(2, 1)
  end
end
