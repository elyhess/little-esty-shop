class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy

  enum status: [ :cancelled, :in_progress, :completed ]

  def total_revenue
    # invoice_items.sum(:unit_price)
    # # write test for this
    invoice_items.sum("invoice_items.unit_price * invoice_items.quantity")
  end

  def self.incomplete_invoices
    joins(:invoice_items)
    .order(created_at: :asc)
    .where.not(status: 2)
    .where.not("invoice_items.status = ?", 2)
    .distinct
  end

  def customer_name
    customer.name
  end
end
