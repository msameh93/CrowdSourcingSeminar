class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_last_seen_at, if: proc { session[:current_user_id] != nil }

  	def current_user
    @_current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
  	end

	private
	def set_last_seen_at
		user = User.find_by(id: session[:current_user_id])
  		user.update_attribute(:last_seen_at, Time.now)
  		user.save
  		session[:last_seen_at] = Time.now
	end
end
