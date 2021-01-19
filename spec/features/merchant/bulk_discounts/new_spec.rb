require 'rails_helper'

RSpec.describe 'As a merchant' do
	describe 'when i visit the merchant bulk bulk_discounts new page' do
		before :each do
			@user = create(:user, role: 0)
			@merchant = create(:merchant, user: @user)

			login_as(@user, scope: :user)
		end

		it 'I can create a new discount' do
			visit new_merchant_bulk_discount_path(@merchant)

			fill_in "bulk_discount[name]", with: "Discount Name"
			fill_in "bulk_discount[quantity_threshold]", with: "10"
			fill_in "bulk_discount[percentage]", with: "20"
			click_button "Create Bulk discount"

			expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
			expect(page).to have_content("Discount Name was created successfully")
			expect(page).to have_content("Discount Name")
			expect(page).to have_content("10")
			expect(page).to have_content("20%")
		end

		it 'it gives an error if fields are filled out correctly' do
			visit new_merchant_bulk_discount_path(@merchant)


			fill_in "bulk_discount[name]", with: "Discount Name"
			fill_in "bulk_discount[quantity_threshold]", with: "x"
			fill_in "bulk_discount[percentage]", with: "20"
			click_button "Create Bulk discount"

			expect(page).to have_content("Quantity threshold is not a number")
			expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
		end
	end
end
