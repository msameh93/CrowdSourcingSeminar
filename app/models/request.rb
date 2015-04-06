class Request < ActiveRecord::Base
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
