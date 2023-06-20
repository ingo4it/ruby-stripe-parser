class ChangeBalanceTransactionDescriptionType < ActiveRecord::Migration[5.1]
  def up
    change_column :balance_transactions, :description, :text
  end

  def down
    change_column :balance_transactions, :description, :string
  end
end
