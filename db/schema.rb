
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

ActiveRecord::Schema.define(version: 20180305024726) do

  create_table "stripe_balance_transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "stripe_id"
    t.string "object"
    t.integer "amount"
    t.string "currency"
    t.text "description"
    t.integer "fee"
    t.integer "net"
    t.string "source"
    t.string "status"
    t.string "stripe_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "payout_id"
    t.datetime "stripe_created"
    t.datetime "available_on"
    t.index ["available_on"], name: "index_stripe_balance_transactions_on_available_on"
    t.index ["payout_id"], name: "index_stripe_balance_transactions_on_payout_id"
    t.index ["status"], name: "index_stripe_balance_transactions_on_status"
    t.index ["stripe_id"], name: "index_stripe_balance_transactions_on_stripe_id", unique: true
    t.index ["stripe_type"], name: "index_stripe_balance_transactions_on_stripe_type"
  end

  create_table "stripe_charge_metadata", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "stripe_charge_id"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stripe_charge_id"], name: "index_stripe_charge_metadata_on_stripe_charge_id"
  end

  create_table "stripe_charges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "stripe_id"
    t.string "object"
    t.integer "amount"
    t.integer "amount_refunded"
    t.string "application"
    t.string "application_fee"
    t.string "balance_transaction"
    t.boolean "captured"
    t.string "currency"
    t.string "customer"
    t.text "description"
    t.string "destination"
    t.string "dispute"
    t.string "failure_code"
    t.string "failure_message"
    t.json "fraud_details"
    t.string "invoice"
    t.string "livemode"
    t.string "on_behalf_of"
    t.string "order"
    t.json "outcome"
    t.boolean "paid"
    t.string "receipt_number"
    t.boolean "refunded"
    t.json "refunds"
    t.string "review"
    t.json "shipping"
    t.json "source"
    t.string "source_transfer"
    t.string "statement_descriptor"
    t.string "status"
    t.string "transfer_group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "stripe_created"
    t.index ["balance_transaction"], name: "index_stripe_charges_on_balance_transaction"
    t.index ["captured"], name: "index_stripe_charges_on_captured"
    t.index ["status"], name: "index_stripe_charges_on_status"
    t.index ["stripe_id"], name: "index_stripe_charges_on_stripe_id", unique: true
  end

  create_table "stripe_customers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "stripe_id"
    t.integer "account_balance"
    t.string "currency"
    t.string "default_source"
    t.boolean "delinquent"
    t.json "discount"
    t.boolean "livemode"
    t.json "metadata"
    t.json "shipping"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "stripe_created"
    t.index ["stripe_id"], name: "index_stripe_customers_on_stripe_id", unique: true
  end

  create_table "stripe_disputes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "stripe_id"
    t.string "object"
    t.integer "amount"
    t.json "balance_transactions"
    t.string "charge"
    t.string "currency"
    t.json "evidence"
    t.json "evidence_details"
    t.boolean "is_charge_refundable"
    t.boolean "livemode"
    t.json "metadata"
    t.string "reason"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "stripe_created"
    t.index ["stripe_id"], name: "index_stripe_disputes_on_stripe_id", unique: true
  end

  create_table "stripe_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "stripe_id"
    t.string "object"
    t.string "api_version"
    t.json "data"
    t.boolean "livemode"
    t.integer "pending_webhooks"
    t.json "request"
    t.string "stripe_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "stripe_created"
    t.index ["stripe_id"], name: "index_stripe_events_on_stripe_id", unique: true
  end

  create_table "stripe_fee_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.bigint "balance_transaction_id"
    t.integer "amount"
    t.string "application"
    t.string "currency"
    t.string "description"
    t.string "stripe_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["balance_transaction_id"], name: "index_stripe_fee_details_on_balance_transaction_id"
  end

  create_table "stripe_payouts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "stripe_id"
    t.string "object"
    t.integer "amount"
    t.string "balance_transaction"
    t.string "currency"
    t.string "description"
    t.string "destination"
    t.string "failure_balance_transaction"
    t.string "failure_code"
    t.string "failure_message"
    t.boolean "livemode"
    t.json "metadata"
    t.string "method"
    t.string "source_type"
    t.string "statement_descriptor"
    t.string "status"
    t.string "stripe_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "stripe_created"
    t.datetime "arrival_date"
    t.index ["stripe_id"], name: "index_stripe_payouts_on_stripe_id", unique: true
  end

  create_table "stripe_refunds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "stripe_id"
    t.string "object"
    t.integer "amount"
    t.string "balance_transaction"
    t.string "charge"
    t.string "currency"
    t.json "metadata"
    t.string "reason"
    t.string "receipt_number"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "stripe_created"
    t.index ["balance_transaction"], name: "index_stripe_refunds_on_balance_transaction"
    t.index ["charge"], name: "index_stripe_refunds_on_charge"
    t.index ["reason"], name: "index_stripe_refunds_on_reason"
    t.index ["status"], name: "index_stripe_refunds_on_status"
    t.index ["stripe_id"], name: "index_stripe_refunds_on_stripe_id", unique: true
  end

  create_table "stripe_transfers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci" do |t|
    t.string "stripe_id"
    t.string "object"
    t.integer "amount"
    t.integer "amount_reversed"
    t.string "balance_transaction"
    t.string "currency"
    t.string "description"
    t.string "destination"
    t.boolean "livemode"
    t.json "metadata"
    t.json "reversals"
    t.boolean "reversed"
    t.string "source_transaction"
    t.string "source_type"
    t.string "transfer_group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "stripe_created"
    t.index ["stripe_id"], name: "index_stripe_transfers_on_stripe_id", unique: true
  end

  add_foreign_key "stripe_balance_transactions", "stripe_payouts", column: "payout_id"
  add_foreign_key "stripe_charge_metadata", "stripe_charges"
  add_foreign_key "stripe_fee_details", "stripe_balance_transactions", column: "balance_transaction_id"
end
