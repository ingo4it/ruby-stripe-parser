class RemoveMetadataFromStripeCharges < ActiveRecord::Migration[5.1]
  def change
    remove_column(:stripe_charges, :metadata, :json)
  end
end
