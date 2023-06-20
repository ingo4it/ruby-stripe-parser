class ChangeChargesDescriptionTypeToText < ActiveRecord::Migration[5.1]
  def change
    change_table :charges do |t|
      t.change :description, :text
    end
  end
end
