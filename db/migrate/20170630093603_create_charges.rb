class CreateCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :charges, options: 'CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci' do |t|
      t.string :stripe_id
      t.string :object
      t.integer :amount
      t.integer :amount_refunded
      t.string :application
      t.string :application_fee
      t.string :balance_transaction
      t.boolean :captured
      t.integer :stripe_created
      t.string :currency
      t.string :customer
      t.string :description
      t.string :destination
      t.string :dispute
      t.string :failure_code
      t.string :failure_message
      t.json :fraud_details
      t.string :invoice
      t.string :livemode
      t.json :metadata
      t.string :on_behalf_of
      t.string :order
      t.json :outcome
      t.boolean :paid
      t.string :receipt_number
      t.boolean :refunded
      t.json :refunds
      t.string :review
      t.json :shipping
      t.json :source
      t.string :source_transfer
      t.string :statement_descriptor
      t.string :status
      t.string :transfer_group

      t.timestamps
    end

    add_index :charges, :stripe_id, unique: true
  end
end
