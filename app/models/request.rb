class Request < ActiveRecord::Base
	has_one :category

	def self.create_request(s_id, r_id, word, hint, cid)
		request = Request.new(
			sender_id: s_id,
			receiver_id: r_id,
			word: word,
			hint: hint,
			category_id: cid)
		request.save
		return request
	end
end
