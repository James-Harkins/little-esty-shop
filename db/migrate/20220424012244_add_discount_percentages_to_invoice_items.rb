class AddDiscountPercentagesToInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    add_column :invoice_items, :discount_percentage, :integer, default: 100
  end
end
