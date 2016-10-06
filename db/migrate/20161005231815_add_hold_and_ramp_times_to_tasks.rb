class AddHoldAndRampTimesToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :ramp_start_time, :integer
    add_column :tasks, :ramp_end_time, :integer
    add_column :tasks, :hold_start_time, :integer
    add_column :tasks, :hold_end_time, :integer
  end
end
