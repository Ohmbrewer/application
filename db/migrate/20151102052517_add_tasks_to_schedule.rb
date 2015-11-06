class AddTasksToSchedule < ActiveRecord::Migration
  def change

    change_table :tasks do |t|
      t.belongs_to :schedule, index: true
    end

  end
end
