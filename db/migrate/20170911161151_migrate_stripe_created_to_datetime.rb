class MigrateStripeCreatedToDatetime < ActiveRecord::Migration[5.1]
  def change
    execute 'UPDATE `balance_transactions` SET `stripe_created_datetime` = FROM_UNIXTIME(`stripe_created`)'
    execute 'UPDATE `charges` SET `stripe_created_datetime` = FROM_UNIXTIME(`stripe_created`)'
    execute 'UPDATE `customers` SET `stripe_created_datetime` = FROM_UNIXTIME(`stripe_created`)'
    execute 'UPDATE `disputes` SET `stripe_created_datetime` = FROM_UNIXTIME(`stripe_created`)'
    execute 'UPDATE `events` SET `stripe_created_datetime` = FROM_UNIXTIME(`stripe_created`)'
    execute 'UPDATE `payouts` SET `stripe_created_datetime` = FROM_UNIXTIME(`stripe_created`)'
    execute 'UPDATE `refunds` SET `stripe_created_datetime` = FROM_UNIXTIME(`stripe_created`)'
    execute 'UPDATE `transfers` SET `stripe_created_datetime` = FROM_UNIXTIME(`stripe_created`)'
  end
end
