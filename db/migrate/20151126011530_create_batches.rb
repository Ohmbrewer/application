class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.datetime :start_time
      t.datetime :stop_time
      t.integer  :status
      t.timestamps null: false
    end

    change_table :rhizomes do |t|
      t.belongs_to :batch, index: true
    end

    change_table :recipes do |t|
      t.belongs_to :batch, index: true
    end
  end
end
