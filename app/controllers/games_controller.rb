class GamesController < ApplicationController
	require 'open-uri'
	before_action :authenticate_user!

	def index
		if user_signed_in?
			return redirect_to controller: "games", action: "home"
		end
	end

	def home
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
    @categories = Category.all
	end

	def send_request
		receiver = User.find_by_uid(session[:receiver_id])
		Request.create_request(current_user.id, receiver.id, params[:word], params[:hint], params[:category_id].to_i)
		session[:receiver_id] = nil
		flash[:success] = "Request sent successfully."
		redirect_to controller: "games", action: "view_requests"
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
		request = Request.find(params[:request_id])
		game1 = Game.where(game_ended: false).find_by_player1_id(request.sender_id)
		game2 = Game.where(game_ended: false).find_by_player2_id(request.receiver_id)
		if game1 
			flash[:danger] = "Other Player is currently busy playing another game. Please try again later."
			redirect_to controller: "games", action: "view_requests"
		elsif game2
			flash[:danger] = "You cannot play more than one game at the same time."
			redirect_to controller: "games", action: "view_requests"
		end
		new_game = Game.create_new_game(request.sender_id, request.receiver_id, request.word, 
				request.hint, request.category_id)
		session[:guess] = nil
		if new_game
			request.delete
			redirect_to controller: "games", action: "game_on", gid: new_game.id
		else
			flash[:danger] = "Something wrong happened. Could not start game."
			redirect_to controller: "games", action: "view_requests"
		end
	end

	def game_on
		@game = Game.find(params[:gid])
		if @game.game_ended?
			if @game.winner.nil?
				flash[:danger] = "Seems that other player ended the game."
			else
				flash[:danger] = "You lose."
			end
			redirect_to controller: "games", action: "home"
		end
		if @game.hints_finished?
			@game.turn = 2
			@game.save
		end
		@word = Word.find_by_game_id(@game.id)
		@hints = Hint.where(word_id: @word.id)
		@guess = session[:guess]
	end

	def leave_game
		game = Game.find(params[:gid])
		game.game_ended = true
		game.save
		redirect_to controller: "games", action: "home"
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
		game.guess = params[:guess]
		game.guess_no = game.guess_no + 1
		game.save
		if word.word == params[:guess]
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
			return redirect_to controller: "games", action: "home"
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
				return redirect_to controller: "games", action: "home"
			else
				game.p2score = game.p2score - 5
				game.save
			end
		end
		redirect_to controller: "games", action: "game_on", gid: game.id
	end

end
