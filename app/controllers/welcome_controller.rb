class WelcomeController < ApplicationController
  
  # index default page where user connects to fb
  def index
  end

  # user's home page which is currently empty
  def home
    @current_user = current_user
    current_user.online = true
    current_user.save
  end

  # fb call back method handling authentication success routine and redirects to user's home
  def callback
  	auth = request.env["omniauth.auth"]
    if auth
      fbid = auth["uid"]
      user = User.find_by_fbid(fbid)
      session[:token] = auth["credentials"]["token"]
      session[:img] = auth["info"]["image"]
      if user
        #sign in
        session[:current_user_id] = user.id
      else
        #create new user
        email = auth["info"]["email"]
        name = auth["info"]["name"]
        newu = User.create_user(email, fbid, name)
        session[:current_user_id] = newu.id
      end
      redirect_to controller: "welcome", action: "home"
    end
    
  end

  # fb callback failure method redirects to index default page
  def callback_failure
    flash[:error] = "Failed to sign in to Facebook!"
  	redirect_to root_url
  end
end
