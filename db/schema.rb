# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171218141203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "spotify_id", null: false
    t.string "spotify_token", null: false
    t.string "spotify_refresh_token"
    t.datetime "spotify_expires_at"
    t.string "email"
    t.string "name"
    t.string "playlist_id"
    t.datetime "last_login_at"
    t.string "last_login_remote_ip"
    t.integer "login_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "check_playlists", default: true, null: false
    t.boolean "check_saved_tracks", default: true, null: false
  end

end
