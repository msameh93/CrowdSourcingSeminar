class UpdateGamesTable < ActiveRecord::Migration
  def change
  	change_column :games, :player1_id, :integer
  	change_column :games, :player2_id, :integer
  end
end
