class CreateUsers < ActiveRecord::Migration[5.0]
	def change
		create_table :users do |t|
			t.string :spotify_id, null: false
			t.string :spotify_token, null: false
			t.string :spotify_refresh_token
			t.datetime :spotify_expires_at

			t.string :email
			t.string :name

			t.string :playlist_id

			t.datetime :last_login_at
			t.string :last_login_remote_ip
			t.integer :login_count, default: 0, null: false

			t.timestamps
		end
	end
end
