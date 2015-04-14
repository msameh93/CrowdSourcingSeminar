class Hint < ActiveRecord::Base
	belongs_to :word, foreign_key: "word_id"

	def self.create_new_hint(wid, hint)
		h = Hint.new(
			word_id: wid,
			hint: hint)
		h.save
		return h
	end
end
