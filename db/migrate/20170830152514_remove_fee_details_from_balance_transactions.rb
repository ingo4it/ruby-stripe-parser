class RemoveFeeDetailsFromBalanceTransactions < ActiveRecord::Migration[5.1]
  def change
    remove_column :balance_transactions, :fee_details, :json
  end
end
