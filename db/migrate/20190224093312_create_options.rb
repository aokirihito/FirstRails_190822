class CreateOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
    	t.references :question, null: false
    	t.string :value
      t.timestamps
    end
    add_foreign_key :options, :questions
  end
end
