
module StripeData
  class Refund < ApplicationRecord
    self.table_name_prefix = 'stripe_'
  end
end
