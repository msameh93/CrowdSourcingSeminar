class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :fbid
      t.string :name
      t.integer :score
      t.boolean :online
      t.datetime :last_seen_at

      t.timestamps null: false
    end
  end
end
