class SessionsController < ApplicationController
	
	before_action :require_user, only: [:destroy]

	def new
		redirect_to '/auth/spotify'
	end

	def create
		user = nil
		user = User.find_or_create_with_auth_hash(auth_hash) if auth_hash

		if user
			set_current_user(user)
			user.spotify
			redirect_after_login
		else
			redirect_to root_url
		end
	end
	
	def failure
		redirect_to root_url
	end

	def destroy
		current_user.update({
			spotify_token: nil,
			spotify_refresh_token: nil,
			spotify_expires_at: nil,
		})

		reset_session
		redirect_to root_url
	end	

protected

	def auth_hash
		request.env['omniauth.auth']
	end

end
