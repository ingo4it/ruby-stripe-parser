
module StripeData
  class BalanceTransaction < ApplicationRecord
    self.table_name_prefix = 'stripe_'

    belongs_to :payout
  end
end
