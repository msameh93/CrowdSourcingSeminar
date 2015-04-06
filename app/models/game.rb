class Game < ActiveRecord::Base
	sync :all
	def self.start_new_game(p1, p2, curr_word, curr_hint)
		game = Game.new(
			player1_id: p1,
			player2_id: p2,
			curr_word: curr_word,
			hint: curr_hint,
			turn: 2,
			guess_no: 0,
			hints_finished: false)
		game.save
		return game
	end
end
