class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.string :word
      t.string :hint
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
