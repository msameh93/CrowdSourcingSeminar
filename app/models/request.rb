class Request < ActiveRecord::Base
	has_one :category
	has_and_belongs_to_many :users

	def self.create_request(s_id, r_id, c_id, word, hint)
		request = Request.new(
			sender_id: s_id,
			receiver_id: r_id,
			category_id: c_id,
			word: word,
			hint: hint)
		request.save
		return request
	end
end
