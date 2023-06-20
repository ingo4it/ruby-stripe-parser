class ChangeColumnTypeOnBalanceTransactions < ActiveRecord::Migration[5.1]
  def change
    execute(%q{
      alter table stripe_balance_transactions
      add available_on_tmp datetime
    })
    execute(%q{
      update stripe_balance_transactions
      set available_on_tmp = from_unixtime(available_on)
    })
    execute(%q{
      alter table stripe_balance_transactions
      drop column available_on
    })
    connection.execute(%q{
      alter table stripe_balance_transactions
      change available_on_tmp available_on datetime
    })     
  end
end
