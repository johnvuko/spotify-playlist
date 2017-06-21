class User < ActiveRecord::Base

	include JT::User::Authentication

	def self.spotify
		User.find_each do |user| 
			begin
				if user.spotify_expires_at.nil? || user.spotify_expires_at < 5.minutes.from_now
					user.refresh_token
				end
				user.spotify
			rescue => e
				ExceptionNotifier.notify_exception(e)
			end
		end
	end

	def spotify
		client = SpotifyService.new(self.spotify_token, self.spotify_id)

		# Get all playlists of the user
		playlists = client.playlists
		playlists_ids = playlists.map {|x| x['id'] }

		# Create the playlist containing tracks to remove
		if !self.playlist_id || !playlists_ids.include?(self.playlist_id)
			playlist_remove = client.create_playlist('Remove from Spotify')
			self.update_column(:playlist_id, playlist_remove['id'])

			# no tracks to search
			return
		end

		# Get the tracks to remove
		tracks_to_remove = client.tracks(self.playlist_id)
		tracks_to_remove_uri = tracks_to_remove.map {|x| x['track']['uri'] }

		# Remove the tracks from all playlists
		client.delete_tracks(playlists_ids, tracks_to_remove_uri)
	end

end
