# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120322111952) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "token"
  end

  create_table "chains", :force => true do |t|
    t.string   "name"
    t.string   "shortname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cities", :force => true do |t|
    t.string   "name"
    t.string   "location"
    t.integer  "country_id"
    t.integer  "state_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "dish_reviews", :force => true do |t|
    t.integer  "rating"
    t.string   "tagline"
    t.string   "review"
    t.integer  "dish_id"
    t.integer  "user_id"
    t.integer  "visit_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "dish_reviews", ["dish_id", "user_id", "visit_id"], :name => "index_dish_reviews_on_dish_id_and_user_id_and_visit_id"

  create_table "dish_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "store_id"
    t.integer  "rank"
  end

  create_table "dishes", :force => true do |t|
    t.string   "name"
    t.string   "alt_name"
    t.integer  "category"
    t.integer  "dish_type_id"
    t.string   "keyword"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "store_id"
    t.integer  "rank"
    t.float    "price"
    t.string   "price_comment"
    t.string   "option_description"
    t.string   "pic_url"
  end

  add_index "dishes", ["dish_type_id"], :name => "index_dishes_on_dish_type_id"

  create_table "pictures", :force => true do |t|
    t.string   "genre"
    t.string   "filename"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "image"
    t.string   "url"
    t.string   "tagline"
    t.string   "description"
    t.integer  "user_id"
    t.integer  "visit_id"
    t.integer  "dish_review_id"
    t.integer  "store_id"
    t.integer  "vote_count"
  end

  create_table "profile_pictures", :force => true do |t|
    t.string   "filename"
    t.string   "image"
    t.string   "url"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "states", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "store_type_relationships", :force => true do |t|
    t.integer  "store_id"
    t.integer  "store_type_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "store_type_relationships", ["store_id", "store_type_id"], :name => "index_store_type_relationships_on_store_id_and_type_id", :unique => true
  add_index "store_type_relationships", ["store_id"], :name => "index_store_type_relationships_on_store_id"
  add_index "store_type_relationships", ["store_type_id"], :name => "index_store_type_relationships_on_type_id"

  create_table "store_types", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.string   "shortname"
    t.string   "email"
    t.string   "phone"
    t.string   "phone2"
    t.string   "address"
    t.string   "postcode"
    t.integer  "city_id"
    t.integer  "chain_id"
    t.string   "keyword"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "fxcode"
  end

  create_table "user_settings", :force => true do |t|
    t.string   "locale"
    t.integer  "current_city"
    t.integer  "user_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "user_settings", ["user_id"], :name => "index_user_settings_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.string   "name"
    t.string   "profilepicurl"
    t.string   "rank"
    t.integer  "status"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birth_date"
    t.string   "phone"
    t.string   "phone2"
    t.string   "address"
    t.integer  "gender"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "visits", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "overall_rating"
    t.integer  "service_rating"
    t.integer  "speed_rating"
    t.integer  "mood_rating"
    t.string   "tagline"
    t.string   "review"
    t.integer  "guest_number"
    t.integer  "city_id"
    t.integer  "store_id"
    t.date     "visit_date"
  end

  add_index "visits", ["city_id", "store_id"], :name => "index_visits_on_city_id_and_store_id"
  add_index "visits", ["user_id", "created_at"], :name => "index_visits_on_user_id_and_created_at"

end
