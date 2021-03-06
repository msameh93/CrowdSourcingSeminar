class GamesController < ApplicationController
	require 'open-uri'
	before_action :authenticate_user!

	def index
		if user_signed_in?
			return redirect_to controller: "games", action: "get_online_friends"
		end
	end

	def get_online_friends
		response = JSON.parse(open("https://graph.facebook.com/me/friends?access_token=#{session[:token]}").read)
		@friends = Array.new(response["data"])
    	@online = Array.new
    	@friends.each { |u|
    		user = User.find_by_uid(u["id"])
    		if user
    			if user.online?
    				@online.push(u)
    			end
    		end
    	}
    	requests = Request.where(receiver_id: current_user.id)
		@req_online = Array.new
		requests.each { |r|
			user  = User.find(r.sender_id)
			if user.online?
    		@req_online.push(r)
			end
		}
    	@categories = Category.all
	end

	def send_request
		receiver = User.find_by_uid(session[:receiver_id])
		Request.create_request(current_user.id, receiver.id, params[:word], params[:hint], params[:category].to_i)
		flash[:success] = "Request sent successfully."
		redirect_to controller: "games", action: "get_online_friends"
	end

	def view_requests
		requests = Request.where(receiver_id: current_user.id)
		@req_online = Array.new
		requests.each { |r|
			user  = User.find(r.sender_id)
			if user.online?
    		@req_online.push(r)
			end
		}
	end

	def delete_request
		request = Request.find(params[:request_id])
		request.destroy
		redirect_to controller: "games", action: "view_requests"
	end

	def start_game
		game1 = Game.where(:game_ended => false).find_by_player1_id(Request.find_by_id(params[:request_id]).sender_id)
		game2 = Game.where(:game_ended => false).find_by_player2_id(Request.find_by_id(params[:request_id]).sender_id)
		game3 = Game.where(:game_ended => false).find_by_player1_id(Request.find_by_id(params[:request_id]).receiver_id)
		game4 = Game.where(:game_ended => false).find_by_player2_id(Request.find_by_id(params[:request_id]).receiver_id)
		if game1 != nil || game2 != nil
			flash[:danger] = "Other Player is currently busy playing another game. Please try again later."
			redirect_to controller: "games", action: "view_requests"
		elsif game3 != nil || game4 != nil
			flash[:danger] = "You cannot play more than one game at the same time."
			redirect_to controller: "games", action: "view_requests"
		end
		new_game = Game.create_new_game(Request.find_by_id(params[:request_id]).sender_id, Request.find_by_id(params[:request_id]).receiver_id, Request.find_by_id(params[:request_id]).word, Request.find_by_id(params[:request_id]).hint, Request.find_by_id(params[:request_id]).category_id)
		if new_game
			Request.find_by_id(params[:request_id]).destroy
			redirect_to controller: "games", action: "game_on", gid: new_game.id
		else
			flash[:danger] = "Something wrong happened. Could not start game."
			redirect_to controller: "games", action: "view_requests"
		end
	end

	def game_on
		@game = Game.find(params[:gid])
		if @game.hints_finished?
			@game.turn = 2
			@game.save
		end
		@word = Word.find_by_game_id(@game.id)
		@hints = Hint.where(word_id: @word.id)
	end

	def leave_game
		game = Game.find(params[:gid])
		game.game_ended= true
		game.winner= 0
		game.save
		redirect_to controller: "games", action: "get_online_friends"
	end

	def get_hint
		game = Game.find(params[:gid])
		if game.turn == 1
			game.turn = 2
		elsif game.turn == 2
			game.turn = 1
		end
		game.p2score = game.p2score - 1
		game.save
		redirect_to controller: "games", action: "game_on", gid: game.id
	end

	def no_more_hints
		game = Game.find(params[:gid])
		game.hints_finished = true
		if game.turn == 1
			game.turn = 2
		elsif game.turn == 2
			game.turn = 1
		end
		game.save
		redirect_to controller: "games", action: "game_on", gid: game.id
	end

	def send_hint
		word = Word.find_by_game_id(params[:gid])
		if word
			hint = Hint.create_new_hint(word.id, params[:hint])
			if hint
				game = Game.find(params[:gid])
				if game.turn == 1
					game.turn = 2
				elsif game.turn == 2
					game.turn = 1
				end
				game.save
			end
		end
		redirect_to controller: "games", action: "game_on", gid: params[:gid]
	end

	def guess_word
		game = Game.find(params[:gid])
		word = Word.find_by_game_id(params[:gid])
		Collect.create_collect(params[:guess], word.category_id)
		game.guess = params[:guess]
		game.guess_no = game.guess_no + 1
		game.save
		if word.word.downcase == params[:guess].downcase
			game.game_ended = true
			game.p1score = 0
			game.winner = 2
			game.save
			flash[:success] = "You win."
			p1 = User.find(game.player1_id)
			p1.score = p1.score + game.p1score
			p1.save
			p2 = User.find(game.player2_id)
			p2.score = p2.score + game.p2score
			p2.save
			return redirect_to controller: "games", action: "get_online_friends"
		else
			if game.guess_no == 3
				game.game_ended = true
				game.p1score = 15
				game.p2score = 0
				game.winner = 1
				game.save
				flash[:danger] = "You lose."
				p1 = User.find(game.player1_id)
				p1.score = p1.score + game.p1score
				p1.save
				p2 = User.find(game.player2_id)
				p2.score = p2.score + game.p2score
				p2.save
				return redirect_to controller: "games", action: "get_online_friends"
			else
				game.p2score = game.p2score - 5
				game.save
				flash[:danger] = "Wrong Guess."
			end
		end
		redirect_to controller: "games", action: "game_on", gid: game.id
	end

	def update_request
		@game= Game.where(game_ended: false).find_by_player1_id(current_user.id)
		game1= Game.where(game_ended: false).find_by_player2_id(current_user.id)
		if(@game != nil)
			@path= "/games/game_on?gid=" + @game.id.to_s 
			@curr_player= 1
		# 	respond_to do |format|
		# 		format.js{redirect_to controller: "games", action: "game_on", gid: game.id}
		# 		format.json{}
		# 	end
		elsif game1 !=nil
			@game = game1
			@path= "/games/game_on?gid=" + @game.id.to_s 
			@curr_player= 2
		# 	respond_to do |format|
		# 		format.js{redirect_to controller: "games", action: "game_on", gid: game1.id}
		# 		format.json{}
		# 	end
		# else
		end
		requests = Request.where(receiver_id: current_user.id)
		@req_online = Array.new
		requests.each { |r|
			user  = User.find(r.sender_id)
			if user.online?
    		@req_online.push(r)
			end
		}
		@count = @req_online.count
		respond_to do |format|
			format.js{render 'update_request'}
			format.json{}
		end
		# end
	end

	def update_game
		@game = Game.find(params[:game])
		if @game.player1_id == current_user.id
			@curr_player = 1
		else
			@curr_player = 2
		end
		@word = Word.find_by_game_id(@game.id)
		@hints = Hint.where(word_id: @word.id)
		@path= "/games/get_online_friends"
		respond_to do |format|
			format.js{render 'update_game'}
			format.json{}
		end
	end

end
