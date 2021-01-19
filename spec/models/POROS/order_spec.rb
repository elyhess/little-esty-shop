require 'rails_helper'

RSpec.describe Order do
  before :each do
    @user = create(:user, role: 0)
    @customer = create(:customer, user: @user)
    @user2 = create(:user, role: 1)
    @merchant = create(:merchant, user: @user2)
    @item = create(:item, merchant: @merchant, unit_price: 2)
    @item2 = create(:item, merchant: @merchant, unit_price: 5)
    @user2 = create(:user, role: 0)
  end

  subject { Cart.new({ "#{@item.id}" => 2, "#{@item2.id}" => 3 }) }

  it 'can create invoices' do
    order = Order.new(subject.contents, @customer)
    order.add_invoice_items
    expect(order.invoices.first.invoice_items.size).to eq(2)
  end

  it 'can return invoices & invoice_items' do
    order = Order.new(subject.contents, @customer)
    order.add_invoice_items
    expect(order.invoices.count).to eq(1)
    expect(order.add_invoice_items.count).to eq(2)
    expect(order.invoices.first.customer_id).to eq(@customer.id)
  end

  it 'gives total dollars saved' do
    @invoice1 = create(:invoice, customer: @customer, merchant: @merchant)
    @invoice_item1 = create(:invoice_item, invoice: @invoice1, item: @item, unit_price: 2, quantity: 2, discount_id: 12, discount_percentage: 20, discount_name: "big discount")
    @invoice_item2 = create(:invoice_item, invoice: @invoice1, item: @item2, unit_price: 5, quantity: 3, discount_id: 12, discount_percentage: 20, discount_name: "big_discount")
    order = Order.new(subject.contents, @customer)
    order.add_invoice_items
    order.all_invoice_items.pop
    order.all_invoice_items.pop
    order.all_invoice_items << @invoice_item1
    order.all_invoice_items << @invoice_item2

    expect(order.total_saved).to eq(3.8)
  end

  it 'gives total dollar amount ' do
    order = Order.new(subject.contents, @customer)
    order.add_invoice_items
    @invoice1 = create(:invoice, customer: @customer, merchant: @merchant)
    @invoice_item1 = create(:invoice_item, invoice: @invoice1, item: @item, unit_price: 2, quantity: 2)
    @invoice_item2 = create(:invoice_item, invoice: @invoice1, item: @item2, unit_price: 5, quantity: 3)
    expect(order.total).to eq(19)
  end

  it 'gives total dollar amount with discount ' do
    order = Order.new(subject.contents, @customer)
    @invoice1 = create(:invoice, customer: @customer, merchant: @merchant)
    @discount_a = @merchant.bulk_discounts.create!(name: "Big discount", quantity_threshold: 1, percentage: 20)
    @invoice_item1 = create(:invoice_item, invoice: @invoice1, item: @item, unit_price: 2, quantity: 2, discount_id: 12, discount_percentage: 20, discount_name: "big discount")
    @invoice_item2 = create(:invoice_item, invoice: @invoice1, item: @item2, unit_price: 5, quantity: 3, discount_id: 12, discount_percentage: 20, discount_name: "big_discount")
    order.add_invoice_items
    order.all_invoice_items.pop
    order.all_invoice_items.pop
    order.all_invoice_items << @invoice_item1
    order.all_invoice_items << @invoice_item2

    expect(order.total).to eq(14)
  end

  it 'gives invoice item total' do
    order = Order.new(subject.contents, @customer)
    @invoice1 = create(:invoice, customer: @customer, merchant: @merchant)
    @invoice_item1 = create(:invoice_item, invoice: @invoice1, item: @item, unit_price: 2, quantity: 2)
    @invoice_item2 = create(:invoice_item, invoice: @invoice1, item: @item2, unit_price: 5, quantity: 3)
    expect(order.invoice_item_total(@invoice_item1)).to eq(4)
  end
end
