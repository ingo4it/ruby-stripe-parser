class AddIndexes < ActiveRecord::Migration[5.1]
  def change
    add_index(:balance_transactions, :status)
    add_index(:balance_transactions, :stripe_type)
    add_index(:balance_transactions, :available_on)

    add_index(:refunds, :charge)
    add_index(:refunds, :status)
    add_index(:refunds, :reason)
    add_index(:refunds, :stripe_created)
    add_index(:refunds, :balance_transaction)

    add_index(:charges, :balance_transaction)
    add_index(:charges, :captured)
    add_index(:charges, :status)
    add_index(:charges, :stripe_created)
  end
end
