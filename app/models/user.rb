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
		tracks_to_remove_uri = tracks_to_remove.map {|x| x['track']['uri'] }

		# Remove the tracks from all playlists
		client.delete_tracks(playlists_ids, tracks_to_remove_uri)
	end

end
