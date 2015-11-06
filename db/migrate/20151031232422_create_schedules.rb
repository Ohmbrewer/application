class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string   :name

      # The root task
      t.belongs_to :root_task

      t.timestamps null: false
    end
  end
end
