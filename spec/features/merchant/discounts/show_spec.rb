require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'As a merchant' do
	describe 'when i visit the merchant bulk discounts show page' do
		before :each do
			@user = create(:user, role: 0)
			@merchant = create(:merchant, user: @user)

			@discount2 = create(:bulk_discount, merchant: @merchant)
			@discount3 = create(:bulk_discount, merchant: @merchant)
			@discount4 = create(:bulk_discount, merchant: @merchant)
			@discount1 = create(:bulk_discount, merchant: @merchant)
			@discount5 = create(:bulk_discount, merchant: @merchant)

			login_as(@user, scope: :user)
		end

		it ' i see all the bulk discounts for that merchant' do
			visit merchant_bulk_discount_path(@merchant, @discount1)

			expect(page).to have_content(@discount1.name)
			expect(page).to have_content(@discount1.quantity_threshold)
			expect(page).to have_content(number_to_percentage(@discount1.percentage, strip_insignificant_zeros: true))
		end
	end
end