class CreateBalanceTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :balance_transactions, options: 'CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci' do |t|
      t.string :stripe_id
      t.string :object
      t.integer :amount
      t.integer :available_on
      t.integer :stripe_created
      t.string :currency
      t.string :description
      t.integer :fee
      t.json :fee_details
      t.integer :net
      t.string :source
      t.string :status
      t.string :stripe_type

      t.timestamps
    end
    add_index :balance_transactions, :stripe_id, unique: true
  end
end
