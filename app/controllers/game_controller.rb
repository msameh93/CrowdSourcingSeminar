class GameController < ApplicationController
	require 'open-uri'

	# method used to send a new request to start a game and has no view (redirects to home page)
	def send_request
		r = Request.create_request(session[:current_user_id], session[:rid], params[:c], params[:q], params[:h])
		redirect_to controller: "welcome", action: "home"
	end

	# method used for viewing user requests page
	def requests
		@current_user = current_user
		requests = Request.where(:receiver_id => current_user.id)
		@req_online = Array.new
		requests.each { |r|
			user  = User.find(r.sender_id)
			if user.online
				if user.last_seen_at.to_i > 15.minutes.ago.to_i
    				@req_online.push(r)
				else
					user.online = false
					user.save    					
    			end
			end
		}
	end

	# method used for viewing online users in order to start a game by sending a request
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

	# the method and view responsible for an ongoing game between two players
	def play_game
		@current_game = Game.find_by(player1_id: session[:current_user_id])
		if !@current_game
			@current_game = Game.find_by(player2_id: session[:current_user_id])
		end
	end

	# when user receives a request and accepts it, he is redirected tp play_game page after deleting the request
	# and creating a new game
	def accept_request
		curr_g1 = Game.find_by(player1_id: params["r_id"])
		curr_g2 = Game.find_by(player2_id: params["r_id"])
		if curr_g1 || curr_g2
			flash[:error] = "Opponent is playing another game!"
		else
			game = Game.start_new_game(params["r_id"], session[:current_user_id], params["w"], params["h"])
			Request.find(params["r_id"]).destroy
			redirect_to controller: "game", action: "play_game"
		end
	end

	# when user receievs a request but decides to delete it and not play the game
	def delete_request
		flash[:success] = "Request deleted successfully!"
		Request.find(params["r_id"]).destroy
		redirect_to controller: "game", action: "requests"
	end
end
