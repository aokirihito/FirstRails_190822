class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
    	t.string :work
    	t.string :quiz
    	t.string :correct
    	t.string :description
    	t.integer :level, default: 1
      t.timestamps
    end
  end
end
