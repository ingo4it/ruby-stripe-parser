class RemoveColumnDescriptionOnCustomers < ActiveRecord::Migration[5.1]
  def change
    remove_column :stripe_customers, :description
  end
end
