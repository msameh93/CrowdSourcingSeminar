class CreateCollects < ActiveRecord::Migration
  def change
    create_table :collects do |t|
    	t.integer :c_id
      	t.string :word

      	t.timestamps null: false
    end
  end
end
