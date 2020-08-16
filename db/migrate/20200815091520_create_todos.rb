class CreateTodos < ActiveRecord::Migration[5.1]
  def change
    create_table :todos do |t|
      t.string :user_id
      t.text :content
      t.datetime :due_date
      t.boolean :done
      t.references :user
      t.timestamps
    end
  end
end
