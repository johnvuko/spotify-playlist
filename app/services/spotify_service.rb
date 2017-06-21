require 'net/http'
require "uri"

# https://developer.spotify.com/
class SpotifyService

	SPOTIFY_MAX_LIMIT = 50
	SPOTIFY_MAX_LIMIT_DELETE = 100

	attr_reader :base_url, :headers, :token, :spotify_id

	def initialize(token, spotify_id)
		@base_url = 'https://api.spotify.com/v1/'
		@token = token
		@spotify_id = spotify_id
		@headers = {
			'Authorization' => "Bearer #{@token}",
			'Content-Type' => 'application/json'
		}
	end

	def playlists
		paginate do |offset|
			params = {
				limit: SPOTIFY_MAX_LIMIT,
				offset: offset	
			}
			request(:get, "users/#{@spotify_id}/playlists", params)
		end
	end

	def create_playlist(name)
		params = {
			name: name,
			public: false
		}
		request(:post, "users/#{@spotify_id}/playlists", params)
	end

	def tracks(playlist_id)
		paginate do |offset|
			params = {
				limit: SPOTIFY_MAX_LIMIT,
				offset: offset	
			}
			request(:get, "users/#{@spotify_id}/playlists/#{playlist_id}/tracks", params)
		end
	end

	def delete_tracks(playlist_ids, tracks_uri)
		groups_tracks_to_remove_uri = tracks_uri.each_slice(SPOTIFY_MAX_LIMIT_DELETE).to_a

		for tracks_to_remove_uri in groups_tracks_to_remove_uri
			for playlist_id in playlist_ids
				params = {
					tracks: tracks_to_remove_uri.map { |uri| { uri: uri } }
				}
				request(:delete, "users/#{@spotify_id}/playlists/#{playlist_id}/tracks", params)
			end
		end
	end

private

	def paginate(&block)
		collection = []
		offset = 0

		result = yield(offset)

		# Probably token revoked
		if result['error']
			Rails.logger.error "[SpotifyService] #{result['error']}"
			return collection
		end

		return collection if result['total'] == 0
		collection += result['items']
		continue = !result['next'].nil?

		if continue
			begin
				offset += SPOTIFY_MAX_LIMIT
				result = yield(offset)
				collection += result['items']
				continue = !result['next'].nil?
			end while continue
		end

		collection
	end

	def request(method, path, params = {})
		uri = URI.parse(@base_url)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true

		url = URI.join(base_url, path)

		case method
		when :get
			url.query = URI.encode_www_form(params)
			response = http.get(url, @headers)
		when :post
			response = http.post(url, JSON.dump(params), @headers)
		when :put
			response = http.put(url, JSON.dump(params), @headers)
		when :delete
			request = Net::HTTP::Delete.new(url, @headers)
			request.body = JSON.dump(params)

			response = http.request(request)
		else
			raise "Invalid method: #{method}"
		end

		return nil if response.body.blank?
		json = JSON.parse(response.body)
	end

end