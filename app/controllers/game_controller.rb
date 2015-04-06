class GameController < ApplicationController
	require 'open-uri'
	enable_sync only: [:send_request]

	def send_request
		r= Request.create_request(session[:current_user_id], session[:rid], params[:q], params[:h])
		sync_new r
		redirect_to controller: "welcome", action: "home"
	end

	def requests
		@current_user = current_user
		requests = Request.where(:receiver_id => current_user.id)
		@request = Array.new
		requests.each { |r|
			user  = User.find(r.sender_id)
			if user.online
				if user.last_seen_at.to_i > 15.minutes.ago.to_i
    				@request.push(r)
				else
					user.online = false
					user.save    					
    			end
			end
		}
	end

	def game
		@current_user = current_user
		response = JSON.parse(open("https://graph.facebook.com/me/friends?access_token=#{session[:token]}").read)
    	@friends = Array.new(response["data"])
    	@online = Array.new
    	@friends.each { |u|
    		user = User.find_by_fbid(u["id"])
    		if user
    			if user.online
    				if user.last_seen_at.to_i > 15.minutes.ago.to_i
    					@online.push(user)
					else
						user.online = false
						user.save    					
    				end
    			end
    		end
    	}
	end
end
