class AddTemporaryCreatedColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :balance_transactions, :stripe_created_datetime, :datetime
    add_column :charges, :stripe_created_datetime, :datetime
    add_column :customers, :stripe_created_datetime, :datetime
    add_column :disputes, :stripe_created_datetime, :datetime
    add_column :events, :stripe_created_datetime, :datetime
    add_column :payouts, :stripe_created_datetime, :datetime
    add_column :refunds, :stripe_created_datetime, :datetime
    add_column :transfers, :stripe_created_datetime, :datetime
  end
end
