class Collect < ActiveRecord::Base
	belongs_to :category, foreign_key: "category_id"

	def self.create_collect(word, cid)
		collect = Collect.new(
			c_id: cid,
			word: word)
		collect.save
		return collect
	end
end
