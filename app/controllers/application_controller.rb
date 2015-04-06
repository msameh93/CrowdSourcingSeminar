class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_last_seen_at, if: proc { session[:current_user_id] != nil }
  before_filter :game_on, if: proc { session[:current_user_id] != nil }

  def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  end

  # method to make sure user is online
	private
	def set_last_seen_at
		user = User.find_by(id: session[:current_user_id])
  	user.update_attribute(:last_seen_at, Time.now)
    user.online = true
  	user.save
  	session[:last_seen_at] = Time.now
	end

  # method to redirect user to game page if a game started
  private
  def game_on
    game1 = Game.find_by(player1_id: session[:current_user_id])
    game2 = Game.find_by(player2_id: session[:current_user_id])
    # if game1 || game2
    #   if !(request.original_url.include?("/game/play_game"))
    #     redirect_to controller: "game", action: "play_game"
    #   end
    # end
  end
end
