class CreateHints < ActiveRecord::Migration
  def change
    create_table :hints do |t|
    	t.integer :word_id
    	t.string :hint

      t.timestamps null: false
    end
  end
end
