
module StripeData
  class FeeDetail < ApplicationRecord
    self.table_name_prefix = 'stripe_'

    belongs_to :balance_transaction
  end
end
