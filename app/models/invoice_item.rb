class InvoiceItem < ApplicationRecord
  belongs_to :item
  has_one :merchant, through: :item
  belongs_to :invoice
  enum status: [ :pending, :packaged, :shipped ]

=begin
  before_save :apply_discount

  def best_discount
    merchant.bulk_discounts.max_by do |discount|
      discount.percentage
    end
  end

  def apply_discount
    unless best_discount.nil?
      if self.item.merchant == best_discount.merchant
        if self.quantity >= best_discount.quantity_threshold
          discount_applied = self.unit_price - (self.unit_price * best_discount.percentage / 100)
          self.unit_price  = discount_applied
        else
          merchant.bulk_discounts.each do |discount|
            if self.quantity >= discount.quantity_threshold
              discount_applied = self.unit_price - (self.unit_price * discount.percentage / 100)
              self.unit_price  = discount_applied
            end
          end
        end
      end
    end
  end
=end
end
