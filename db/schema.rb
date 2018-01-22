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

ActiveRecord::Schema.define(version: 20180122074806) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.bigint "facebook_id"
    t.string "facebook_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facebook_id"], name: "index_categories_on_facebook_id"
  end

  create_table "naver_line_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.integer "user_id"
    t.string "line_user_id"
    t.string "display_name"
    t.string "picture_url"
    t.string "status_message"
    t.time "line_time_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_naver_line_accounts_on_user_id"
  end

  create_table "naver_line_contents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "line_user_id"
    t.string "display_name"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_user_id"], name: "index_naver_line_contents_on_line_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4" do |t|
    t.string "line_user_id"
    t.integer "max_distance"
    t.float "min_score", limit: 24
    t.boolean "random_type", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "get_google_result", default: false
    t.index ["line_user_id"], name: "index_users_on_line_user_id"
  end

end
