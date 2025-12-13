class CreateExampleTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :example_tasks do |t|

      t.timestamps
    end
  end
end
