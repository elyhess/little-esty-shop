require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
describe 'validations' do
	it { should validate_presence_of :name }
	it { should validate_numericality_of :percentage }
	it { should validate_numericality_of :quantity_threshold }
end

describe 'relationships' do
	it { should belong_to :merchant }
	it { should have_many(:items).through(:merchant) }
	it { should have_many(:invoice_items).through(:items) }
end

describe 'instance methods' do
	before :each do
		@user = create(:user, role: 1)
		@merchant = create(:merchant, user: @user)

		@user1 = create(:user, role: 0)
		@merchant1 = create(:merchant, user: @user1)

		@customer = create(:customer, user: @user)

		@discount_a = @merchant.bulk_discounts.create!(name: "Big discount", quantity_threshold: 10, percentage: 20)
		@discount_b = @merchant1.bulk_discounts.create!(name: "Big discount", quantity_threshold: 10, percentage: 35)

		@item_a = create(:item, merchant: @merchant, unit_price: 10)
		@item_b = create(:item, merchant: @merchant1, unit_price: 20)

		@invoice_1 = create(:invoice, customer: @customer, merchant: @merchant)
		@invoice_2 = create(:invoice, customer: @customer, merchant: @merchant)

		@invoice_item_1 = create(:invoice_item, status: 1, item: @item_a, invoice: @invoice_1, quantity: 10, unit_price: 10, discount_id: @discount_a.id)
		@invoice_item_2 = create(:invoice_item, status: 0, item: @item_b, invoice: @invoice_2, quantity: 5, unit_price: 20,  discount_id: @discount_b.id)
	end

	it '#has_pending_invoice_items?' do
		expect(@discount_b.has_pending_invoice_items?).to eq(true)
		expect(@discount_a.has_pending_invoice_items?).to eq(false)
	end

end

describe 'class methods' do
end

end

