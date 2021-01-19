class Order
  attr_reader :all_invoice_items

  def initialize(data, customer)
    @customer = customer
    @contents = data
    invoices
    @all_invoice_items = []
  end

  def item_list
    Item.where(id: @contents.keys)
  end

  def order_items
    item_quantities = {}
    @contents.each do |item_id, quantity|
      item_quantities[Item.find(item_id.to_i)] = quantity
    end
    item_quantities
  end

  def invoices
    item_list.map do |item|
      Invoice.find_by(customer: @customer, merchant: item.merchant, status: 1) ||
        Invoice.create(customer: @customer, merchant: item.merchant, status: 1)
    end.uniq
  end

  def add_invoice_items
    order_items.map do |item, quantity|
      invoice = Invoice.find_by(customer: @customer, merchant: item.merchant)
      invitem = InvoiceItem.create(quantity: quantity, status: 0, item: item, invoice: invoice)
      @all_invoice_items << invitem
    end
  end

  def total_saved
    @all_invoice_items.sum do |invoice_item|
      discount_rate = invoice_item.discount_percentage.to_f
      original_price = invoice_item.item.unit_price
      ((original_price * discount_rate) * invoice_item.quantity) / 100
    end
  end

  def total
    @all_invoice_items.sum do |invoice_item|
      invoice_item_total(invoice_item)
    end
  end

  def invoice_item_total(invoice_item)
    invoice_item.unit_price * invoice_item.quantity
  end


end
