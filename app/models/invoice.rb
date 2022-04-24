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

  

  def discounted_revenue

  end
end
