class AddDurationToTasks < ActiveRecord::Migration
  def change

    change_table :tasks do |t|

      t.integer :duration, default: 0

    end

  end
end
