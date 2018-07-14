ActiveRecord::Schema.define(version: 20180712025159) do

  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.text "player_1_board"
    t.text "player_2_board"
    t.integer "winner"
    t.integer "player_1_turns"
    t.integer "player_2_turns"
    t.integer "current_turn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_games", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "game_id"
    t.index ["game_id"], name: "index_user_games_on_game_id"
    t.index ["user_id"], name: "index_user_games_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address"
    t.string "name"
    t.string "password_digest"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
  end

  add_foreign_key "user_games", "games"
  add_foreign_key "user_games", "users"
end
