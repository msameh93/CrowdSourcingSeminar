class Word < ActiveRecord::Base
	has_many :hints
	belongs_to :category, foreign_key: "category_id"
	belongs_to :game, foreign_key: "game_id"

	def self.create_new_word(gid, word, hint, cid)
		w = Word.new(
			category_id: cid,
			game_id: gid,
			word: word)
		w.save
		if w
			h = Hint.create_new_hint(w.id, hint)
			if !h
				w.destroy
			end
		end
		return w
	end
end
