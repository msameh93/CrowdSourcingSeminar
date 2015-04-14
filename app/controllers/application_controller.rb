class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	after_filter :user_activity

	private
	def user_activity
  	current_user.try :touch
	end

  def after_sign_in_path_for(resource)
    "/games/home"
  end

  def after_sign_out_path_for(resource)
    root_url
  end
end
