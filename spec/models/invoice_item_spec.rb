require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe 'validations' do
  end

  describe 'relationships' do
    it {should belong_to :item}
    it {should belong_to :invoice}
  end

  describe 'instance methods' do
    describe "#apply_discounts" do
	    it 'should not apply bulk discount' do
        @user = create(:user, role: 1)
        @merchant = create(:merchant, user: @user)
        @customer = create(:customer, user: @user)

        @merchant.bulk_discounts.create!(name: "Big discount", quantity_threshold: 10, percentage: 20)


        @item_1 = create(:item, merchant: @merchant, unit_price: 10)
        @item_2 = create(:item, merchant: @merchant, unit_price: 10)

        @invoice_1 = create(:invoice, customer: @customer, merchant: @merchant)

        @invoice_item_1 = create(:invoice_item, status: 0, item: @item_1, invoice: @invoice_1, quantity: 1, unit_price: 10)
        @invoice_item_2 = create(:invoice_item, status: 0, item: @item_2, invoice: @invoice_1, quantity: 1, unit_price: 10)

        expect(@invoice_item_1.unit_price).to eq(10)
        expect(@invoice_item_2.unit_price).to eq(10)
      end

      it 'should apply bulk discount to item a and not to item b' do
        @user = create(:user, role: 1)
        @merchant = create(:merchant, user: @user)
        @customer = create(:customer, user: @user)
        @merchant.bulk_discounts.create!(name: "Big discount", quantity_threshold: 10, percentage: 20)

        @item_a = create(:item, merchant: @merchant, unit_price: 10)
        @item_b = create(:item, merchant: @merchant, unit_price: 20)

        @invoice_1 = create(:invoice, customer: @customer, merchant: @merchant)

        @invoice_item_1 = create(:invoice_item, status: 0, item: @item_a, invoice: @invoice_1, quantity: 10, unit_price: 10)
        @invoice_item_2 = create(:invoice_item, status: 0, item: @item_b, invoice: @invoice_1, quantity: 5, unit_price: 20)

        expect(@invoice_item_1.unit_price).to eq(8)
        expect(@invoice_item_2.unit_price).to eq(20)
      end

      it 'should apply bulk discount to item A at 20% and item B at 30%' do
        @user = create(:user, role: 1)
        @merchant = create(:merchant, user: @user)
        @customer = create(:customer, user: @user)

        @discount_a = @merchant.bulk_discounts.create!(name: "Big discount", quantity_threshold: 10, percentage: 20)
        @discount_b = @merchant.bulk_discounts.create!(name: "Bigger discount", quantity_threshold: 15, percentage: 30)

        @item_a = create(:item, merchant: @merchant, unit_price: 10)
        @item_b = create(:item, merchant: @merchant, unit_price: 20)

        @invoice_a = create(:invoice, customer: @customer, merchant: @merchant)

        @invoice_item_1 = create(:invoice_item, status: 0, item: @item_a, invoice: @invoice_a, quantity: 12, unit_price: 10)
        @invoice_item_2 = create(:invoice_item, status: 0, item: @item_b, invoice: @invoice_a, quantity: 15, unit_price: 20)

        expect(@invoice_item_1.unit_price).to eq(8)
        expect(@invoice_item_2.unit_price).to eq(14)
      end

      it 'should apply bulk discount to at 20% to both item A and item B' do
        @user = create(:user, role: 1)
        @merchant = create(:merchant, user: @user)
        @customer = create(:customer, user: @user)

        @discount_a = @merchant.bulk_discounts.create!(name: "Big discount", quantity_threshold: 10, percentage: 20)
        @discount_b = @merchant.bulk_discounts.create!(name: "lesser discount", quantity_threshold: 15, percentage: 15)

        @item_a = create(:item, merchant: @merchant, unit_price: 10)
        @item_b = create(:item, merchant: @merchant, unit_price: 20)

        @invoice_a = create(:invoice, customer: @customer, merchant: @merchant)

        @invoice_item_1 = create(:invoice_item, status: 0, item: @item_a, invoice: @invoice_a, quantity: 12, unit_price: 10)
        @invoice_item_2 = create(:invoice_item, status: 0, item: @item_b, invoice: @invoice_a, quantity: 15, unit_price: 20)

        expect(@invoice_item_1.unit_price).to eq(8)
        expect(@invoice_item_2.unit_price).to eq(16)
      end

      it 'should discount item A at 20%, item B at 30% and item C should not be discounted' do
        @user = create(:user, role: 1)
        @merchant = create(:merchant, user: @user)
        @customer = create(:customer, user: @user)

        @user2 = create(:user, role: 1)
        @merchant2 = create(:merchant, user: @user)
        @customer2 = create(:customer, user: @user)

        @discount_a = @merchant.bulk_discounts.create!(name: "Big discount", quantity_threshold: 10, percentage: 20)
        @discount_b = @merchant.bulk_discounts.create!(name: "lesser discount", quantity_threshold: 15, percentage: 30)

        @item_a = create(:item, merchant: @merchant, unit_price: 10)
        @item_b = create(:item, merchant: @merchant, unit_price: 10)
        @item_c = create(:item, merchant: @merchant2, unit_price: 10)

        @invoice_a = create(:invoice, customer: @customer, merchant: @merchant)

        @invoice_item_1 = create(:invoice_item, status: 0, item: @item_a, invoice: @invoice_a, quantity: 12, unit_price: 10)
        @invoice_item_2 = create(:invoice_item, status: 0, item: @item_b, invoice: @invoice_a, quantity: 15, unit_price: 10)
        @invoice_item_3 = create(:invoice_item, status: 0, item: @item_c, invoice: @invoice_a, quantity: 15, unit_price: 10)

        expect(@invoice_item_1.unit_price).to eq(8)
        expect(@invoice_item_2.unit_price).to eq(7)
        expect(@invoice_item_3.unit_price).to eq(10)
      end
    end
  end

  describe 'class methods' do 
  end
  
end
