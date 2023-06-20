class ChangeColumnTypeOnPayouts < ActiveRecord::Migration[5.1]
  def change    
    execute(%q{
      alter table stripe_payouts
      add arrival_date_tmp datetime
    })
    execute(%q{
      update stripe_payouts
      set arrival_date_tmp = from_unixtime(arrival_date)
    })
    execute(%q{
      alter table stripe_payouts
      drop column arrival_date
    })
    connection.execute(%q{
      alter table stripe_payouts
      change arrival_date_tmp arrival_date datetime
    })    
  end  
end
