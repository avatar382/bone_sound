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

ActiveRecord::Schema.define(version: 20170701203153) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "business_name"
    t.string "phone"
    t.string "gatorlink_id"
    t.string "chartfield"
    t.integer "affiliation"
    t.integer "account_type"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["account_type"], name: "index_accounts_on_account_type"
    t.index ["affiliation"], name: "index_accounts_on_affiliation"
    t.index ["deleted_at"], name: "index_accounts_on_deleted_at"
  end

  create_table "charges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "account_id"
    t.integer "type"
    t.string "description"
    t.datetime "paid_at"
    t.decimal "amount", precision: 10
    t.integer "payment_method"
    t.integer "added_by"
    t.string "semester_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_charges_on_account_id"
    t.index ["payment_method"], name: "index_charges_on_payment_method"
    t.index ["semester_code"], name: "index_charges_on_semester_code"
    t.index ["type"], name: "index_charges_on_type"
  end

end
