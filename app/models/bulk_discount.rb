class BulkDiscount < ApplicationRecord
  validates :percentage, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 100}
  validates_numericality_of :quantity_threshold
  validates_presence_of :name

  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items

  def has_pending_invoice_items?
    pending = invoice_items.where(status: :pending, discount_id: (self.id))
    pending.size > 0
  end

end
