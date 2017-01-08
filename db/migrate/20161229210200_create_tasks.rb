class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.references :user
      t.string :state
      t.string :attachment

      t.timestamps
    end
  end
end
