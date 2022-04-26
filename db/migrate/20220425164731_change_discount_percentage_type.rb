class ChangeDiscountPercentageType < ActiveRecord::Migration[5.2]
  def change
    change_column :invoice_items, :discount_percentage, :float
  end
end
