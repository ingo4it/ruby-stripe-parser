
module StripeData
  class Payout < ApplicationRecord
    self.table_name_prefix = 'stripe_'

    has_many :balance_transactions
  end
end
