class BulkDiscount < ApplicationRecord
  validates :percentage, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 100}
  validates_numericality_of :quantity_threshold
  validates_presence_of :name
  belongs_to :merchant
end
