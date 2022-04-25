class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :discounts, through: :merchants

  enum status: ["in progress".to_sym, :completed, :cancelled]

  def self.incomplete
    joins(:invoice_items)
    .where('invoice_items.status != ?', '2')
    .distinct
    .order(:id)
  end

  def self.sorted_by_newest
    order(created_at: :desc)
  end

  def dates
    created_at.strftime("%A, %B %d, %Y")
  end

  def full_name
    customer.first_name + " " +  customer.last_name
  end

  def total_revenue
    invoice_items.sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def apply_discounts
    invoice_items.each do |invoice_item|
      invoice_item.discounts.distinct.order(percentage: :desc).each do |discount|
        if discount.quantity_threshold <= invoice_item.quantity && invoice_item.discount_percentage == 100
          invoice_item.update(discount_percentage: invoice_item.discount_percentage - discount.percentage)
        end
      end
    end
    invoice_items
  end

  def discounted_revenue
    apply_discounts.sum('(invoice_items.unit_price * invoice_items.quantity) * (invoice_items.discount_percentage / 100)')
  end
end
