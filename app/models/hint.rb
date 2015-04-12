class Hint < ActiveRecord::Base
	belongs_to :word, foreign_key: "word_id"
end
