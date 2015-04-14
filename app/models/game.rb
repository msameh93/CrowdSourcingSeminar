class Game < ActiveRecord::Base
	has_many :words

	def self.create_new_game(p1, p2, word, hint, cid)
		game = Game.new(
			player1_id: p1,
			player2_id: p2,
			turn: 2,
			guess_no: 0,
			hints_finished: false,
			game_ended: false)
		game.save
		if game
			word = Word.create_new_word(game.id, word, hint, cid)
			if !word
				game.destroy
			end
		end
		return game
	end
end
