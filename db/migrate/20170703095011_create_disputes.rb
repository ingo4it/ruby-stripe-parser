class CreateDisputes < ActiveRecord::Migration[5.1]
  def change
    create_table :disputes, options: 'CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci' do |t|
      t.string :stripe_id
      t.string :object
      t.integer :amount
      t.json :balance_transactions
      t.string :charge
      t.integer :stripe_created
      t.string :currency
      t.json :evidence
      t.json :evidence_details
      t.boolean :is_charge_refundable
      t.boolean :livemode
      t.json :metadata
      t.string :reason
      t.string :status

      t.timestamps
    end
    add_index :disputes, :stripe_id, unique: true
  end
end
