class Word < ActiveRecord::Base
	has_many :hints
	belongs_to :category, foreign_key: "category_id"
	belongs_to :game, foreign_key: "game_id"
end
