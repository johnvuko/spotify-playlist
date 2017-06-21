module JT::User::Authentication
	extend ActiveSupport::Concern

	included do

		validates :spotify_id, presence: true, uniqueness: true
		
		before_save :downcase_email

		scope :search_by_email, ->(email) { where(email: email.to_s.downcase.strip) }

	end

	class_methods do

		def find_or_create_with_auth_hash(auth_hash)
			expires_at = nil
			expires_at = Time.at(auth_hash['credentials']['expires_at']) if auth_hash['credentials']['expires_at']

			if user = self.where(spotify_id: auth_hash['uid']).first
				user.update!({
					spotify_token: auth_hash['credentials']['token'],
					spotify_refresh_token: auth_hash['credentials']['refresh_token'],
					spotify_expires_at: expires_at,

					email: auth_hash['info']['email'],
					name: auth_hash['info']['name'],
				})
				return user 
			end

			self.create!({
				spotify_id: auth_hash['uid'],
				spotify_token: auth_hash['credentials']['token'],
				spotify_refresh_token: auth_hash['credentials']['refresh_token'],
				spotify_expires_at: expires_at,

				email: auth_hash['info']['email'],
				name: auth_hash['info']['name'],
			})
		end

	end

	def refresh_token
		client_options = OmniAuth::Strategies::Spotify.default_options[:client_options].to_h.symbolize_keys
		client = OAuth2::Client.new(SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET, client_options)

		access_token = OAuth2::AccessToken.new(client, self.spotify_token, {
			refresh_token: self.spotify_refresh_token,
			expires_at: self.spotify_expires_at
		})

		begin
			access_token = access_token.refresh!
		rescue OAuth2::Error => e
			return false
		end

		expires_at = nil
		expires_at = Time.at(access_token.expires_at) if access_token.expires_at
		
		self.update!({
			spotify_token: access_token.token,
			spotify_refresh_token: access_token.refresh_token || self.spotify_refresh_token,
			spotify_expires_at: expires_at
		})
	end

	def downcase_email
		self.email = self.email.downcase.strip if self.email
	end

	def increment_login_stats!(remote_ip)
		attributes = {
			last_login_at: Time.now,
			last_login_remote_ip: remote_ip,
			login_count: (self.login_count || 0) + 1
		}

		self.update_columns(attributes)
	end

end
