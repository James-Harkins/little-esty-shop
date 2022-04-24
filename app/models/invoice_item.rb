class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :discounts, through: :merchant

  enum status: [:pending, :packaged, :shipped]


  def self.total_revenue
    sum('unit_price * quantity')
  end

  def self.total_revenue_for_invoice(invoice_id)
    sorted_invoices = self.where(invoice_id: invoice_id)
    sorted_invoices.sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def self.apply_discounts_for_invoice(invoice_id)
    sorted_invoice_items = self.where(invoice_id: invoice_id)
    sorted_invoice_items.each do |invoice_item|
      if invoice_item.invoice_id == invoice_id
        invoice_item.discounts.distinct.order(percentage: :desc).each do |discount|
          if discount.quantity_threshold <= invoice_item.quantity && invoice_item.discount_percentage == 100
            invoice_item.update(discount_percentage: invoice_item.discount_percentage - discount.percentage)
          end
        end
      end
    end
    sorted_invoice_items
  end

  def self.discounted_revenue_for_invoice(invoice_id)
    total = 0
    apply_discounts_for_invoice(invoice_id).each do |invoice_item|
      total += ((invoice_item.unit_price * invoice_item.quantity) * (invoice_item.discount_percentage.to_f / 100))
    end
    total
  end

  def invoice_dates
    invoice.created_at.strftime("%A, %B %d, %Y")
  end

  def self.ready_to_ship
    where(status: "packaged").order('created_at DESC')
  end

  def belongs_to_merchant(merchant_id)
    item.merchant_id == merchant_id.to_i
  end

  def applied_discount
    discounts.order(percentage: :desc).find do |discount|
      discount.quantity_threshold <= quantity
    end
  end
end
