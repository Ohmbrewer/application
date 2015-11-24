class ScheduleProfile < ActiveRecord::Base

  belongs_to :schedule
  belongs_to :equipment_profile

end