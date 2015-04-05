class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :sender_id
      t.string :receiver_id
      t.string :word
      t.string :hint

      t.timestamps null: false
    end
  end
end
