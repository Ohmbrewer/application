class AddTriggerToTask < ActiveRecord::Migration
  def change
      add_column :tasks, :trigger, :integer
  end
end
