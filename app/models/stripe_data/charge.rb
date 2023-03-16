
module StripeData
  class Charge < ApplicationRecord
    self.table_name_prefix = 'stripe_'

    has_one :charge_metadata, foreign_key: 'stripe_charge_id'
  end
end
