class AddJobIdToTask < ActiveRecord::Migration
  def change

    add_column :tasks, :job_id, :uuid, index: true

  end
end
