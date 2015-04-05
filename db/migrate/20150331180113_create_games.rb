class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :player1_id
      t.string :player2_id
      t.string :curr_word
      t.string :hint
      t.integer :turn
      t.integer :guess_no
      t.boolean :hints_finished

      t.timestamps null: false
    end
  end
end
