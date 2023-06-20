class AddStripePrefixToTables < ActiveRecord::Migration[5.1]
  def change
    rename_table :balance_transactions, :stripe_balance_transactions
    rename_table :charge_metadata, :stripe_charge_metadata
    rename_table :customers, :stripe_customers
    rename_table :disputes, :stripe_disputes
    rename_table :events, :stripe_events
    rename_table :fee_details, :stripe_fee_details
    rename_table :payouts, :stripe_payouts
    rename_table :refunds, :stripe_refunds
    rename_table :transfers, :stripe_transfers
  end
end
