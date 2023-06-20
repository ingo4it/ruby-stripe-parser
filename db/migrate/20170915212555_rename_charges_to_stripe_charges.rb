class RenameChargesToStripeCharges < ActiveRecord::Migration[5.1]
  def change
    rename_table :charges, :stripe_charges
  end
end
