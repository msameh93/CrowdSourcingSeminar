class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	after_filter :user_activity
  before_filter :requests

	private
	def user_activity
  	current_user.try :touch
	end

  def after_sign_in_path_for(resource)
    "/games/get_online_friends"
  end

  def after_sign_out_path_for(resource)
    root_url
  end

  def requests
    requests = Request.where(receiver_id: current_user.id)
    @req_online = Array.new
    requests.each { |r|
      user  = User.find(r.sender_id)
      if user.online?
        @req_online.push(r)
      end
    }
  end

end
