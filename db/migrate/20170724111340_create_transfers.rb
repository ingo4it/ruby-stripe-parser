class CreateTransfers < ActiveRecord::Migration[5.1]
  def change
    create_table :transfers do |t|
      t.string :stripe_id
      t.string :object
      t.integer :amount
      t.integer :amount_reversed
      t.string :balance_transaction
      t.integer :stripe_created
      t.string :currency
      t.string :description
      t.string :destination
      t.boolean :livemode
      t.json :metadata
      t.json :reversals
      t.boolean :reversed
      t.string :source_transaction
      t.string :source_type
      t.string :transfer_group

      t.timestamps
    end
    add_index :transfers, :stripe_id, unique: true
  end
end
