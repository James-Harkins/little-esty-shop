class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant
  enum status: [:pending, :packaged, :shipped]

  def self.total_revenue
    sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def self.discounted_revenue
    all.reduce(0) do |total, invoice_item|
      total += invoice_item.total_revenue * invoice_item.discount_multiplier
    end
  end


  def self.ready_to_ship
    where(status: "packaged").order('created_at DESC')
  end

  def applied_bulk_discount
    bulk_discounts.order(percentage: :desc)
                  .where('bulk_discounts.quantity_threshold <= ?', quantity)
                  .first
  end

  def total_revenue
    unit_price * quantity
  end

  def discount_multiplier
    if applied_bulk_discount
      (100.0 - applied_bulk_discount.percentage) / 100
    else
      1
    end
  end

  def invoice_date
    invoice.created_at
  end

  def belongs_to_merchant(merchant_id)
    item.merchant_id == merchant_id
  end
end
