class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  has_many :bulk_discounts

  enum status: [:disabled, :enabled]

  def most_popular_items
    items.joins(:transactions)
    .select('items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
    .where("transactions.result = 'success' AND invoices.status = 1")
    .group('items.id')
    .order('total_revenue desc')
    .limit(5)
  end

  def distinct_invoices
    invoices.distinct
  end

  def self.top_five_by_revenue
    joins(items: :transactions)
    .select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
    .where(transactions: { result: "success" })
    .group('merchants.id')
    .order('total_revenue desc')
    .limit(5)
  end

  def total_revenue_to_dollars
    "$" + (sprintf "%.2f",total_revenue.to_f/100).to_s
  end

  def best_day
    invoices.select('invoices.created_at, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
          .group('invoices.created_at')
          .order('revenue desc')
          .first
          .created_at
  end
end
