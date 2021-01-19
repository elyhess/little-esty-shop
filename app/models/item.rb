class Item < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates :unit_price, presence: true, format: { with: /\A\d{0,11}(\.?\d{0,2})?\z/ }, numericality: true
  
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  enum status: [ :disabled, :enabled ]

  def best_discount(quantity)
    merchant.bulk_discounts
            .where("bulk_discounts.quantity_threshold <= ?", quantity)
            .order(percentage: :desc)
            .limit(1)
  end

  def best_day
    invoices.select('invoices.created_at AS created_at, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
    .group('invoices.created_at')
    .max
    .date
  end

  def self.with_enabled_merchants
    joins(:merchant)
      .where("merchants.status = ?", 1)
  end
end
