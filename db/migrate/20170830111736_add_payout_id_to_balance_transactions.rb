class AddPayoutIdToBalanceTransactions < ActiveRecord::Migration[5.1]
  def change
    add_reference :balance_transactions, :payout, foreign_key: true
  end
end
