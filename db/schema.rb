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

ActiveRecord::Schema.define(version: 20190209040049) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
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
    t.string "ufid"
    t.string "uf_college"
    t.float "credit", limit: 24
    t.index ["account_type"], name: "index_accounts_on_account_type"
    t.index ["affiliation"], name: "index_accounts_on_affiliation"
    t.index ["deleted_at"], name: "index_accounts_on_deleted_at"
  end

  create_table "audits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "chargefiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "charges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "account_id"
    t.integer "charge_type"
    t.string "description"
    t.datetime "paid_at"
    t.decimal "amount", precision: 8, scale: 2
    t.integer "payment_method"
    t.integer "added_by"
    t.string "semester_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "membership_id"
    t.integer "chargefile_id"
    t.datetime "refunded_at"
    t.string "material_sku"
    t.integer "material_count"
    t.index ["account_id"], name: "index_charges_on_account_id"
    t.index ["charge_type"], name: "index_charges_on_charge_type"
    t.index ["chargefile_id"], name: "index_charges_on_chargefile_id"
    t.index ["deleted_at"], name: "index_charges_on_deleted_at"
    t.index ["payment_method"], name: "index_charges_on_payment_method"
    t.index ["semester_code"], name: "index_charges_on_semester_code"
  end

  create_table "materials", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "sku"
    t.decimal "price", precision: 8, scale: 2
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "count"
    t.integer "minimum_count"
  end

  create_table "memberships", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.decimal "price", precision: 8, scale: 2
    t.integer "duration"
    t.integer "affiliation"
    t.boolean "is_renewal"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
