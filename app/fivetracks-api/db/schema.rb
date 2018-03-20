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

ActiveRecord::Schema.define(version: 20180315171811) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"

  create_table "artist", id: :integer, default: nil, force: :cascade do |t|
    t.text "name", null: false
    t.text "realname"
    t.text "profile"
    t.text "data_quality"
    t.index ["name"], name: "artist_name_idx"
  end

  create_table "artist_alias", id: :serial, force: :cascade do |t|
    t.integer "artist_id", null: false
    t.text "alias_name", null: false
    t.integer "alias_artist_id"
  end

  create_table "artist_namevariation", id: :serial, force: :cascade do |t|
    t.integer "artist_id", null: false
    t.text "name", null: false
  end

  create_table "artist_url", id: :serial, force: :cascade do |t|
    t.integer "artist_id", null: false
    t.text "url", null: false
  end

  create_table "group_member", id: false, force: :cascade do |t|
    t.integer "group_artist_id", null: false
    t.integer "member_artist_id", null: false
    t.text "member_name", null: false
    t.index ["member_artist_id", "group_artist_id"], name: "membership_idx"
  end

  create_table "indexed_tracks", id: false, force: :cascade do |t|
    t.integer "track_id"
  end

  create_table "label", id: :integer, default: nil, force: :cascade do |t|
    t.text "name", null: false
    t.text "contact_info"
    t.text "profile"
    t.integer "parent_id"
    t.text "parent_name"
    t.text "data_quality"
  end

  create_table "label_url", id: :serial, force: :cascade do |t|
    t.integer "label_id", null: false
    t.text "url", null: false
    t.index ["label_id"], name: "label_idx"
  end

  create_table "master", id: :integer, default: nil, force: :cascade do |t|
    t.text "title", null: false
    t.integer "year"
    t.integer "main_release", null: false
    t.text "data_quality"
    t.index ["main_release"], name: "main_release_idx"
  end

  create_table "master_artist", id: :serial, force: :cascade do |t|
    t.integer "master_id", null: false
    t.integer "artist_id", null: false
    t.text "anv"
    t.text "join_string"
    t.text "role"
    t.index ["artist_id"], name: "artist_idx"
    t.index ["master_id"], name: "master_idx"
  end

  create_table "master_genre", id: :serial, force: :cascade do |t|
    t.integer "master_id", null: false
    t.text "genre"
    t.index ["master_id"], name: "master_genre_master_idx"
  end

  create_table "master_style", id: :serial, force: :cascade do |t|
    t.integer "master_id", null: false
    t.text "style"
    t.index ["master_id"], name: "master_style_master_idx"
    t.index ["master_id"], name: "master_video_master_idx"
  end

  create_table "master_video", id: false, force: :cascade do |t|
    t.integer "master_id", null: false
    t.integer "duration"
    t.text "title"
    t.text "description"
    t.text "uri"
  end

  create_table "queue_tracks", id: :serial, force: :cascade do |t|
    t.integer "track_id"
    t.integer "release_id"
    t.string "queue"
    t.boolean "in_library"
    t.float "popularity_rating"
    t.float "underground_rating"
    t.float "similarity_rating"
    t.float "total_rating"
  end

  create_table "release", id: :integer, default: nil, force: :cascade do |t|
    t.text "title", null: false
    t.text "released"
    t.text "country"
    t.text "notes"
    t.text "data_quality"
    t.integer "master_id"
    t.index ["master_id"], name: "release_master_idx"
  end

  create_table "release_artist", id: :serial, force: :cascade do |t|
    t.integer "release_id", null: false
    t.integer "artist_id", null: false
    t.integer "extra", null: false
    t.text "anv"
    t.text "join_string"
    t.text "role"
    t.text "tracks"
    t.index ["artist_id"], name: "release_artist_artist_idx"
    t.index ["release_id"], name: "release_artist_release_idx"
  end

  create_table "release_company", id: :serial, force: :cascade do |t|
    t.integer "release_id", null: false
    t.integer "company_id", null: false
    t.text "company_name", null: false
    t.text "entity_type"
    t.text "entity_type_name"
    t.text "uri"
    t.index ["release_id"], name: "release_company_release_idx"
  end

  create_table "release_format", id: :serial, force: :cascade do |t|
    t.integer "release_id", null: false
    t.text "name"
    t.decimal "qty"
    t.text "text_string"
    t.text "descriptions"
    t.index ["release_id"], name: "release_format_release_idx"
  end

  create_table "release_genre", id: :serial, force: :cascade do |t|
    t.integer "release_id", null: false
    t.text "genre"
    t.index ["release_id"], name: "release_genre_release_idx"
  end

  create_table "release_identifier", id: :serial, force: :cascade do |t|
    t.integer "release_id", null: false
    t.text "description"
    t.text "identifier_type"
    t.text "value"
    t.index ["release_id"], name: "release_identifier_release_idx"
  end

  create_table "release_label", id: false, force: :cascade do |t|
    t.integer "release_id", null: false
    t.integer "label_id"
    t.text "label_name", null: false
    t.text "catno"
    t.index ["label_id"], name: "release_label_label_idx"
    t.index ["release_id"], name: "release_label_release_idx"
  end

  create_table "release_style", id: false, force: :cascade do |t|
    t.integer "release_id", null: false
    t.text "style"
    t.index ["release_id"], name: "release_style_release_idx"
  end

  create_table "release_track", id: :integer, default: nil, force: :cascade do |t|
    t.integer "release_id", null: false
    t.integer "sequence", null: false
    t.text "position"
    t.integer "parent"
    t.text "title"
    t.text "duration"
    t.index ["release_id"], name: "release_track_release_idx"
  end

  create_table "release_track_artist", id: :serial, force: :cascade do |t|
    t.integer "release_id", null: false
    t.integer "track_sequence", null: false
    t.integer "artist_id", null: false
    t.boolean "extra", null: false
    t.text "anv"
    t.text "join_string"
    t.text "role"
    t.text "tracks"
    t.integer "release_track_id"
    t.index ["artist_id"], name: "release_track_artist_artist_idx"
    t.index ["release_id"], name: "release_track_artist_release_idx"
    t.index ["release_track_id"], name: "release_track_artist_release_track_idx"
    t.index ["track_sequence"], name: "release_track_artist_track_idx"
  end

  create_table "release_video", id: :serial, force: :cascade do |t|
    t.integer "release_id", null: false
    t.integer "duration"
    t.text "title"
    t.text "description"
    t.text "uri"
    t.index ["release_id"], name: "release_video_release_idx"
  end

  create_table "search_tracks", force: :cascade do |t|
    t.integer "track_id"
    t.integer "score"
    t.integer "release_id"
    t.text "artist_ids", default: [], array: true
    t.string "title"
    t.string "release_title"
    t.string "artists"
  end

  create_table "track_search", id: false, force: :cascade do |t|
    t.integer "release_id"
    t.integer "track_id"
    t.integer "artist_ids", array: true
    t.text "song"
    t.text "release"
    t.text "artists"
    t.index ["release_id"], name: "track_search_release_idx"
  end

  add_foreign_key "artist_alias", "artist", name: "fk_artist_id", on_delete: :cascade
  add_foreign_key "artist_namevariation", "artist", name: "fk_artist_id", on_delete: :cascade
  add_foreign_key "artist_url", "artist", name: "fk_artist_id", on_delete: :cascade
  add_foreign_key "label_url", "label", name: "fk_label_id", on_delete: :cascade
  add_foreign_key "master_artist", "master", name: "fk_master_id", on_delete: :cascade
  add_foreign_key "master_genre", "master", name: "fk_master_id", on_delete: :cascade
  add_foreign_key "master_style", "master", name: "fk_master_id", on_delete: :cascade
  add_foreign_key "master_video", "master", name: "fk_master_id", on_delete: :cascade
  add_foreign_key "queue_tracks", "release", name: "queue_tracks_release_id_fkey"
  add_foreign_key "queue_tracks", "release_track", column: "track_id", name: "queue_tracks_track_id_fkey"
  add_foreign_key "release_artist", "release", name: "fk_release_id", on_delete: :cascade
  add_foreign_key "release_company", "release", name: "fk_release_id", on_delete: :cascade
  add_foreign_key "release_format", "release", name: "fk_release_id", on_delete: :cascade
  add_foreign_key "release_genre", "release", name: "fk_release_id", on_delete: :cascade
  add_foreign_key "release_identifier", "release", name: "fk_release_id", on_delete: :cascade
  add_foreign_key "release_label", "release", name: "fk_release_id", on_delete: :cascade
  add_foreign_key "release_style", "release", name: "fk_release_id", on_delete: :cascade
  add_foreign_key "release_track", "release", name: "fk_release_id", on_delete: :cascade
  add_foreign_key "release_track_artist", "release", name: "fk_release_id", on_delete: :cascade
  add_foreign_key "release_video", "release", name: "fk_release_id", on_delete: :cascade
end
