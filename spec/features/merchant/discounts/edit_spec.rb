require 'rails_helper'

RSpec.describe 'As a merchant' do
	describe 'when i am on a merchant bulk discount edit page' do

		before :each do
			@user = create(:user, role: 0)
			@merchant = create(:merchant, user: @user)

			@discount = create(:bulk_discount, merchant: @merchant, name: "A")

			login_as(@user, scope: :user)
		end

		it 'I can update the bulk discounts information' do
			visit edit_merchant_bulk_discount_path(@merchant, @discount)

			fill_in "bulk_discount[name]", with: "Discount Name"
			fill_in "bulk_discount[quantity_threshold]", with: "10"
			fill_in "bulk_discount[percentage]", with: "20"

			click_button "Update Bulk discount"

			expect(current_path).to eq(merchant_bulk_discounts_path(@merchant, @discount))
			expect(page).to have_content("Discount Name was updated successfully!")
			expect(page).to have_content("Discount Name")
			expect(page).to have_content("10")
			expect(page).to have_content("20%")
		end
	end
end
