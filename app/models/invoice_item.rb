class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]


  def self.total_revenue
    sum('unit_price * quantity')
  end

  def item_name
    item.name
  end

  def invoice_dates
    invoice.created_at.strftime("%A, %B %d, %Y")
  end

  def self.ready_to_ship
    where(status: "packaged").order('created_at DESC')
  end

  def belongs_to_merchant(merchant_id)
    if item.merchant_id == merchant_id.to_i
      return true
    else
      return false
    end
  end
end
