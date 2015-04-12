class Word < ActiveRecord::Base
	has_many :hints
	belongs_to :category, foreign_key: "category_id"
	belongs_to :game, foreign_key: "game_id"

	def self.create_new_word(cid, gid, w, h)
		word = Word.new(
			category_id: cid,
			game_id: gid,
			word: w)
		word.save
		if word
			hint = Hint.create_new_hint(word.id, h)
			return hint
		end
		return word
	end
end
