class Game < ActiveRecord::Base
	has_many :words

	def self.create_new_game(p1, p2, word, hint, cid)
		game = Game.new(
			player1_id: p1,
			player2_id: p2,
			winner: 0,
			turn: 2,
			guess_no: 0,
			hints_finished: false,
			game_ended: false,
			just_started: true,
			p1score: 15,
			p2score: 15)
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
