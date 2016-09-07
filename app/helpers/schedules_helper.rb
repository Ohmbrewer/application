module SchedulesHelper
  def add_schedule_message(schedule)
    "Schedule <strong>#{schedule.name}</strong> successfully added!"
  end

  def update_schedule_message(schedule)
    "Schedule <strong>#{schedule.name}</strong> successfully updated!"
  end

  def delete_schedule_message(schedule)
    "Schedule <strong>#{schedule.name}</strong> successfully deleted!"
  end

  def delete_multiple_schedules_success_message
    'Schedules deleted!'
  end

  def delete_multiple_schedules_fail_message
    'No Schedules were deleted. Did you select any?'
  end

  def delete_multiple_schedules_mix_message(pre, post)
    "Something strange happened... #{pre - post} Schedules weren't deleted."
  end
end
