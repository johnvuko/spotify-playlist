class AddOptionsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :check_playlists, :boolean, null: false, default: true
    add_column :users, :check_saved_tracks, :boolean, null: false, default: true

    User.update_all(check_saved_tracks: false)
  end
end
