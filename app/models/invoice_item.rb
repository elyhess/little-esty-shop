class InvoiceItem < ApplicationRecord
  belongs_to :item
  has_one :merchant, through: :item
  belongs_to :invoice
  enum status: [ :pending, :packaged, :shipped ]

  before_create :add_applicable_discounts

  def set_discount(discount)
    self.discount_id = discount.id
    self.discount_percentage = discount.percentage
    self.discount_name = discount.name
  end

  def add_applicable_discounts
    discount = self.item.best_discount(self.quantity)
    if discount.empty?
      self.unit_price = self.item.unit_price
    else
      set_discount(discount.first)
      self.unit_price = (self.item.unit_price * ((100 - discount.first.percentage.to_f) / 100))
    end
  end


=begin
  def best_discount
    merchant.bulk_discounts.max_by do |discount|
      discount.percentage
      set_discount(discount)
    end
  end
=end

=begin
  def best_discount(quantity)
    merchant.bulk_discounts.where("bulk_discounts.quantity_threshold >= ?", quantity).order(:percentage).limit(1)
  end
=end

=begin
  def set_discount(discount)
    self.discount_id = discount.id
    self.discount_percentage = discount.percentage
    self.discount_name = discount.name
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
              set_discount(discount)
            end
          end
        end
      end
    end
  end

  def check_discounts(data)
    merchant.bulk_discounts.each do |discount|
      data.each do |quantity, price_per_item|
        if quantity > discount.quantity_threshold
          price_per_item * (1 - discount.percentage)
        end
      end
    end
  end
=end

end
