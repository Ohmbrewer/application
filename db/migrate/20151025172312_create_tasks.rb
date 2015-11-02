class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string  :type
      t.integer :status
      t.jsonb   :update_data, default: '{}', index: true, using: :gin

      t.timestamps null: false
      t.belongs_to :equipment
    end

    change_table :equipment_statuses do |t|
      t.belongs_to :task, index: true
    end
  end
end
