class Game < ActiveRecord::Base
	has_many :words
	has_and_belongs_to_many :users

	def self.create_new_game(p1, p2, cid, word, hint)
		game = Game.new(
			player1_id: p1,
			player2_id: p2,
			turn: 2,
			guess_no: 0,
			hints_finished: false)
		game.save
		if game
			word = Word.create_new_word(cid, game.id, word, hint)
			return word
		end
		return game
	end
end
