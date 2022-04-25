class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates_presence_of :percentage
  validates :percentage, numericality: { only_integer: true, less_than: 100, greater_than: 0 }
  validates_presence_of :quantity_threshold
  validates :quantity_threshold, numericality: { only_integer: true, greater_than: 1 }
end
