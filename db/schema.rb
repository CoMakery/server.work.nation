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

ActiveRecord::Schema.define(version: 20170427004420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "confirmations", force: :cascade do |t|
    t.integer "confirmer_id"
    t.integer "skill_claim_id"
    t.integer "skill_claimant_id"
    t.float "rating"
    t.text "ipfs_reputon_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "address"
    t.text "contact"
    t.text "image_url"
    t.text "permanode_id"
  end

  create_table "skill_claims", force: :cascade do |t|
    t.integer "skill_claimant_id"
    t.text "name"
    t.integer "project_count", default: 0
    t.integer "confirmations_count", default: 0
    t.text "ipfs_reputon_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.text "uport_address"
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "avatar_image_ipfs_key"
    t.text "banner_image_ipfs_key"
  end

end
