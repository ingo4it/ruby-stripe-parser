
module StripeData
  class Customer < ApplicationRecord
    self.table_name_prefix = 'stripe_'
  end
end
