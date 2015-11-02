class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string     :name
      t.string     :type

      # Each recipe has an associated schedule and ingredient list
      t.belongs_to :schedule
      t.timestamps null: false
    end
  end
end
