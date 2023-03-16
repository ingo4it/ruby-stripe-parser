
module StripeData
  class Dispute < ApplicationRecord
    self.table_name_prefix = 'stripe_'
  end
end
