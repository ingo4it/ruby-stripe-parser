class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events, options: 'CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci' do |t|
      t.string :stripe_id
      t.string :object
      t.string :api_version
      t.integer :stripe_created
      t.json :data
      t.boolean :livemode
      t.integer :pending_webhooks
      t.json :request
      t.string :stripe_type

      t.timestamps
    end
    add_index :events, :stripe_id, unique: true
  end
end
