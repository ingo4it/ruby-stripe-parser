class AddIndexOnBalanceTransactions < ActiveRecord::Migration[5.1]
  def change
    add_index(:stripe_balance_transactions, :available_on)
  end
end
