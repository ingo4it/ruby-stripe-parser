
module StripeData
  class Transfer < ApplicationRecord
    self.table_name_prefix = 'stripe_'
  end
end
