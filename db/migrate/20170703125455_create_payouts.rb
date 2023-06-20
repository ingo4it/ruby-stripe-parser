class CreatePayouts < ActiveRecord::Migration[5.1]
  def change
    create_table :payouts, options: 'CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci' do |t|
      t.string :stripe_id
      t.string :object
      t.integer :amount
      t.integer :arrival_date
      t.string :balance_transaction
      t.integer :stripe_created
      t.string :currency
      t.string :description
      t.string :destination
      t.string :failure_balance_transaction
      t.string :failure_code
      t.string :failure_message
      t.boolean :livemode
      t.json :metadata
      t.string :method
      t.string :source_type
      t.string :statement_descriptor
      t.string :status
      t.string :stripe_type

      t.timestamps
    end
    add_index :payouts, :stripe_id, unique: true
  end
end
