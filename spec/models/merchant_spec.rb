require 'rails_helper'

RSpec.describe Merchant, type: :model do
  before :each do
    Merchant.destroy_all
    Customer.destroy_all
    Transaction.destroy_all
    Invoice.destroy_all
    Item.destroy_all
    InvoiceItem.destroy_all

    @merchant = create(:merchant)

    @customer_1 = create(:customer)
    @invoice_1 = create(:invoice, merchant: @merchant, customer: @customer_1)
    @invoice_2 = create(:invoice, merchant: @merchant, customer: @customer_1)
    create(:transaction, result: 1, invoice: @invoice_1)
    create(:transaction, result: 1, invoice: @invoice_2)

    @customer_2 = create(:customer)
    @invoice_3 = create(:invoice, merchant: @merchant, customer: @customer_2)
    @invoice_4 = create(:invoice, merchant: @merchant, customer: @customer_2)
    create(:transaction, result: 1, invoice: @invoice_3)
    create(:transaction, result: 1, invoice: @invoice_3)
    create(:transaction, result: 1, invoice: @invoice_3)
    create(:transaction, result: 1, invoice: @invoice_4)

    @customer_5 = create(:customer)
    @invoice_5 = create(:invoice, merchant: @merchant, customer: @customer_5)
    @invoice_6 = create(:invoice, merchant: @merchant, customer: @customer_5)
    create(:transaction, result: 1, invoice: @invoice_5)
    create(:transaction, result: 1, invoice: @invoice_5)
    create(:transaction, result: 1, invoice: @invoice_6)

    @customer_4 = create(:customer)
    @invoice_7 = create(:invoice, merchant: @merchant, customer: @customer_4)
    create(:transaction, result: 1, invoice: @invoice_7)
    create(:transaction, result: 1, invoice: @invoice_7)
    create(:transaction, result: 1, invoice: @invoice_7)
    create(:transaction, result: 1, invoice: @invoice_7)
    create(:transaction, result: 1, invoice: @invoice_7)

    @customer_3 = create(:customer)
    @invoice_8 = create(:invoice, merchant: @merchant, customer: @customer_3)
    create(:transaction, result: 0, invoice: @invoice_7)

    @customer_6 = create(:customer)
    @invoice_9 = create(:invoice, merchant: @merchant, customer: @customer_6)
    @invoice_10 = create(:invoice, merchant: @merchant, customer: @customer_6)
    create(:transaction, result: 1, invoice: @invoice_9)

    create_list(:item, 6, merchant: @merchant)

    5.times do
      create(:invoice_item, item: Item.first, invoice: Invoice.all.sample, status: 2, quantity: 10, unit_price: 3)
    end

    5.times do
      create(:invoice_item, item: Item.second, invoice: Invoice.all.sample, status: 1, quantity: 10, unit_price: 4)
    end

    5.times do
      create(:invoice_item, item: Item.third, invoice: Invoice.all.sample, status: 0, quantity: 10, unit_price: 3)
    end
  end

  describe 'class methods' do
    before :each do
      @merchant1 = create(:merchant, status: 0)
      @merchant2 = create(:merchant, status: 0)
      @merchant3 = create(:merchant, status: 1)
    end
    it '::enabled' do
      expect(Merchant.enabled).to eq([@merchant3])
    end
    it '::disabled' do
      expect(Merchant.disabled).to eq([@merchant, @merchant1, @merchant2])
    end
  end

  describe 'instance methods' do
    it '#top_5_customers' do
      expect(@merchant.customers.count).to eq(10)
      top = [@customer_4.first_name, @customer_2.first_name, @customer_5.first_name, @customer_1.first_name, @customer_6.first_name]
      actual = @merchant.top_5.map { | x | x[:first_name]}
      expect(actual).to eq(top)
    end

    it '#ready_to_ship' do
      expected = @merchant.ready_to_ship
      expect(expected.length).to eq(10)
    end

    it '#top_5_items' do
      # @merchant.top_5_items
      # expect(@merchant.top_5_items).to eq()
    end
  end
end
