Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, "735690599886041", "663f8b2e206e11cc040fa7cb571bae84",
	:scope => 'email,user_friends,friends_online_presence'

	OmniAuth.config.on_failure = Proc.new { |env|
 	 OmniAuth::FailureEndpoint.new(env).redirect_to_failure
	}
end