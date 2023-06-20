class DropOldStripeCreated < ActiveRecord::Migration[5.1]
  def change
    remove_column :balance_transactions, :stripe_created, :integer
    remove_column :charges, :stripe_created, :integer
    remove_column :customers, :stripe_created, :integer
    remove_column :disputes, :stripe_created, :integer
    remove_column :events, :stripe_created, :integer
    remove_column :payouts, :stripe_created, :integer
    remove_column :refunds, :stripe_created, :integer
    remove_column :transfers, :stripe_created, :integer

    rename_column :balance_transactions, :stripe_created_datetime, :stripe_created
    rename_column :charges, :stripe_created_datetime, :stripe_created
    rename_column :customers, :stripe_created_datetime, :stripe_created
    rename_column :disputes, :stripe_created_datetime, :stripe_created
    rename_column :events, :stripe_created_datetime, :stripe_created
    rename_column :payouts, :stripe_created_datetime, :stripe_created
    rename_column :refunds, :stripe_created_datetime, :stripe_created
    rename_column :transfers, :stripe_created_datetime, :stripe_created
  end
end
