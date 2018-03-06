class User < ActiveRecord::Base

	include JT::User::Authentication

	def self.spotify
		User.find_each do |user| 
			Raven.user_context({
				id: user.id,
				email: user.email,
				username: user.name,
			})

			begin
				if user.spotify_expires_at.nil? || user.spotify_expires_at < 5.minutes.from_now
					user.refresh_token
				end

				if !user.access_token_is_expired?
					user.spotify
				end
			rescue => e
				Raven.capture_exception(e)
			end

			Raven.user_context({})
		end
	end

	def spotify
		client = SpotifyService.new(self.spotify_token, self.spotify_id)

		# Get all playlists of the user
		playlists = client.playlists
		playlist_ids = playlists.map {|x| x['id'] }

		# Create the playlist containing tracks to remove
		if !self.playlist_id || !playlist_ids.include?(self.playlist_id)
			# Search playlist by name
			duplicate_playlists = playlists.select {|p| p['name'] == SpotifyService::PLAYLIST_NAME }
			if duplicate_playlists.size > 1
				playlist = client.fix_duplicates(duplicate_playlists)
				self.update_column(:playlist_id, playlist['id']) if playlist
			elsif duplicate_playlists.size == 1
				playlist = duplicate_playlists[0]
				self.update_column(:playlist_id, playlist['id']) if playlist
			else
				playlist = client.create_playlist
				self.update_column(:playlist_id, playlist['id']) if playlist

				# no tracks to search
				return
			end
		end

		# Get the tracks to remove
		tracks_to_remove = client.tracks(self.playlist_id)
		return if tracks_to_remove.empty?

		# Remove the tracks from all playlists
		if self.check_playlists?
			client.delete_tracks(playlists, tracks_to_remove)
		end

		# Remove the tracks from "My Music" library
		if self.check_saved_tracks?
			client.delete_tracks_from_saved_tracks(tracks_to_remove)
		end
	end

end
