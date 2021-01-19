require 'rails_helper'

RSpec.describe "When a user is on the checkout page" do
	it "Their invoice is created and discounts are applied to the invoice items" do
		@user = create(:user, role: 1)
		@merchant = create(:merchant, user: @user, status: 1)
		@customer = create(:customer, user: @user)

		@user1 = create(:user, role: 0)
		@merchant1 = create(:merchant, user: @user1, status: 1)
		@customer = create(:customer, user: @user1)

		@discount_a = @merchant.bulk_discounts.create!(name: "Small discount", quantity_threshold: 1, percentage: 10)
		@discount_b = @merchant.bulk_discounts.create!(name: "Big discount", quantity_threshold: 2, percentage: 20)

		@item_a = create(:item, merchant: @merchant, unit_price: 10)
		@item_b = create(:item, merchant: @merchant, unit_price: 20)

		@invoice_1 = create(:invoice, customer: @customer, merchant: @merchant)

		@invoice_item_1 = create(:invoice_item, status: 1, item: @item_a, invoice: @invoice_1, quantity: 1, unit_price: 10, discount_id: @discount_a.id)
		@invoice_item_2 = create(:invoice_item, status: 0, item: @item_b, invoice: @invoice_1, quantity: 2, unit_price: 20,  discount_id: @discount_a.id)

		login_as(@user1, scope: :user)

		visit root_path

		within("#item-#{@item_a.id}") do
			click_button "Add To Cart"
		end

		within("#item-#{@item_b.id}") do
			click_button "Add To Cart"
		end

		within("#item-#{@item_b.id}") do
			click_button "Add To Cart"
		end

		click_on "Cart (3)"

		within(".level-right") do
			click_on 'Check Out'
		end

		expect(page).to have_content(@invoice_item_1.item.name)
		expect(page).to have_content(@invoice_item_1.quantity)
		expect(page).to have_content(@invoice_item_1.discount_name)


		expect(page).to have_content(@invoice_item_2.item.name)
		expect(page).to have_content(@invoice_item_2.quantity)
		expect(page).to have_content(@invoice_item_2.discount_name)

		within all(".section")[2] do
			expect(page).to have_content("You save: $9")
			expect(page).to have_content("Total: $41")
		end

		expect(page).to have_link("Pay")
	end
end