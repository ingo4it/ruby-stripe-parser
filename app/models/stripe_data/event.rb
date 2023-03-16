
module StripeData
  class Event < ApplicationRecord
    self.table_name_prefix = 'stripe_'
  end
end
