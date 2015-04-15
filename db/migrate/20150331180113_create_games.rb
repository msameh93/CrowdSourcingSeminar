class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :player1_id
      t.integer :player2_id
      t.integer :turn
      t.integer :guess_no
      t.integer :p1score
      t.integer :p2score
      t.integer :winner
      t.boolean :hints_finished
      t.boolean :game_ended
      t.string :guess

      t.timestamps null: false
    end
  end
end
