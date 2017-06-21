SPOTIFY_CLIENT_ID = Rails.application.secrets.spotify_client_id
SPOTIFY_CLIENT_SECRET = Rails.application.secrets.spotify_client_secret

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :spotify, SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET, scope: 'playlist-read-private user-library-read playlist-modify-public playlist-modify-private user-library-modify'
end
