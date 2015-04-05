class User < ActiveRecord::Base

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
