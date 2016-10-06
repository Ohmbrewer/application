class AddStartTimeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :start_time, :integer
  end
end
