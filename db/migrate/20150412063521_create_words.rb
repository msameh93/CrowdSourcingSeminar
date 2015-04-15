class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
    	t.integer :category_id
    	t.integer :game_id
    	t.string :word

      t.timestamps null: false
    end
  end
end
