
module StripeData
  class ChargeMetadata < ApplicationRecord
    self.table_name_prefix = 'stripe_'

    # Maybe make this model polymorphic
    belongs_to :charge, foreign_key: 'stripe_charge_id'
  end
end
