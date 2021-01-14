require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'As a merchant' do
	describe 'when i visit the merchant discounts index' do
		before :each do
			@user = create(:user, role: 0)
			@merchant = create(:merchant, user: @user)

			@discount2 = create(:discount, merchant: @merchant, name: "A")
			@discount3 = create(:discount, merchant: @merchant, name: "B")
			@discount4 = create(:discount, merchant: @merchant, name: "C")
			@discount1 = create(:discount, merchant: @merchant, name: "D")
			@discount5 = create(:discount, merchant: @merchant, name: "E")

			login_as(@user, scope: :user)
		end

		it ' i see all the discounts for that merchant' do
			visit merchant_discounts_path(@merchant)

			expect(page).to have_link(@discount1.name)
			expect(page).to have_link(@discount2.name)
			expect(page).to have_link(@discount3.name)
			expect(page).to have_link(@discount4.name)
			expect(page).to have_link(@discount5.name)

			expect(page).to have_content(@discount1.quantity_threshold)
			expect(page).to have_content(@discount2.quantity_threshold)
			expect(page).to have_content(@discount3.quantity_threshold)
			expect(page).to have_content(@discount4.quantity_threshold)
			expect(page).to have_content(@discount5.quantity_threshold)

			expect(page).to have_content(number_to_percentage(@discount1.percentage, strip_insignificant_zeros: true))
			expect(page).to have_content(number_to_percentage(@discount2.percentage, strip_insignificant_zeros: true))
			expect(page).to have_content(number_to_percentage(@discount3.percentage, strip_insignificant_zeros: true))
			expect(page).to have_content(number_to_percentage(@discount4.percentage, strip_insignificant_zeros: true))
			expect(page).to have_content(number_to_percentage(@discount5.percentage, strip_insignificant_zeros: true))
		end

		it 'I can click a discount name and be taken to its show page' do
			visit merchant_discounts_path(@merchant)

			click_link(@discount1.name)
			expect(current_path).to eq(merchant_discount_path(@merchant, @discount1))
		end
	end
end
