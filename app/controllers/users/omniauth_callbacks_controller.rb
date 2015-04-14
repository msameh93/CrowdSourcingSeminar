class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

   def facebook
    auth = request.env["omniauth.auth"]
    @user = User.from_omniauth(auth)
    if @user.persisted?
      session[:token] = auth["credentials"]["token"]
      session[:img] = auth["info"]["image"]
      session[:name] = auth["info"]["name"]
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:success, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = auth
      redirect_to new_user_registration_url
    end
  end

  def failure
    set_flash_message(:danger, :error, :kind => "Facebook")
    redirect_to root_url
  end
end
