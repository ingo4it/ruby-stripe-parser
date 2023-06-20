class CreateRefunds < ActiveRecord::Migration[5.1]
  def change
    create_table :refunds, options: 'CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci' do |t|
      t.string :stripe_id
      t.string :object
      t.integer :amount
      t.string :balance_transaction
      t.string :charge
      t.integer :stripe_created
      t.string :currency
      t.json :metadata
      t.string :reason
      t.string :receipt_number
      t.string :status

      t.timestamps
    end
    add_index :refunds, :stripe_id, unique: true
  end
end
