class CreateFeeDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :fee_details do |t|
      t.references :balance_transaction, foreign_key: true
      t.integer :amount
      t.string :application
      t.string :currency
      t.string :description
      t.string :stripe_type

      t.timestamps
    end
  end
end
