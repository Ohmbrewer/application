class AddEndTimeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :end_time, :integer
  end
end
