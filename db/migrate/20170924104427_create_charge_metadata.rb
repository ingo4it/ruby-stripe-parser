class CreateChargeMetadata < ActiveRecord::Migration[5.1]
  def change
    create_table :charge_metadata do |t|
      t.references :stripe_charge, foreign_key: true
      t.json :data

      t.timestamps
    end
  end
end
