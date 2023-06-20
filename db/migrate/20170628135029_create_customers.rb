class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers, options: 'CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci' do |t|
      t.string :stripe_id
      t.integer :account_balance
      t.string :currency
      t.integer :stripe_created
      t.string :default_source
      t.boolean :delinquent
      t.string :description
      t.json :discount
      t.boolean :livemode
      t.json :metadata
      t.json :shipping

      t.timestamps
    end

    add_index :customers, :stripe_id, unique: true
  end
end
