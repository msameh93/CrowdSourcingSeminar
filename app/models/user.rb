class User < ActiveRecord::Base
	has_and_belongs_to_many :requests
	has_and_belongs_to_many :games

	def self.create_user(email, fbid, name)
		user = User.new(
			email: email,
			fbid: fbid,
			name: name,
			score: 0,
			online: false,
			last_seen_at: Time.now)
		user.save
		return user
	end
end
