class AddFieldsToExampleTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :example_tasks, :title, :string
    add_column :example_tasks, :description, :text
  end
end
