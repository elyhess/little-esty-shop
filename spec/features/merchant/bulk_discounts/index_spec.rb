require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'As a merchant' do
	describe 'when i visit the merchant bulk bulk_discounts index' do
		before :each do
			@user = create(:user, role: 0)
			@user1 = create(:user, role: 0)
			@merchant = create(:merchant, user: @user)
			@merchant1 = create(:merchant, user: @user1)

			@discount2 = create(:bulk_discount, merchant: @merchant, name: "discount of a name")
			@discount3 = create(:bulk_discount, merchant: @merchant, name: "B")
			@discount4 = create(:bulk_discount, merchant: @merchant, name: "C")
			@discount1 = create(:bulk_discount, merchant: @merchant, name: "D")
			@discount5 = create(:bulk_discount, merchant: @merchant, name: "E")

			login_as(@user, scope: :user)
		end
		it ' i see all the bulk bulk_discounts for that merchant' do
			visit merchant_bulk_discounts_path(@merchant)

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

		it 'I can click a bulk discount name and be taken to its show page' do
			visit merchant_bulk_discounts_path(@merchant)

			click_link(@discount1.name)
			expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount1))
		end

		it 'I can delete a bulk discount' do
			visit merchant_bulk_discounts_path(@merchant)

			first('.buttons').click_button('Delete')

			within("#discounts") do
				expect(page).to_not have_content(@discount2.name)
			end

			expect(page).to have_content("#{@discount2.name} was deleted.")
		end

		it 'cant be deleted if it has pending invoice items', :skip_before do
			@user = create(:user, role: 1)
			@merchant = create(:merchant, user: @user)
			@customer = create(:customer, user: @user)

			@user1 = create(:user, role: 0)
			@merchant1 = create(:merchant, user: @user1)
			@customer = create(:customer, user: @user1)

			login_as(@user, scope: :user)


			@discount_a = @merchant.bulk_discounts.create!(name: "Big discount", quantity_threshold: 10, percentage: 20)
			@discount_b = @merchant.bulk_discounts.create!(name: "Big discount", quantity_threshold: 10, percentage: 35)

			@item_a = create(:item, merchant: @merchant, unit_price: 10)
			@item_b = create(:item, merchant: @merchant, unit_price: 20)

			@invoice_1 = create(:invoice, customer: @customer, merchant: @merchant)
			@invoice_2 = create(:invoice, customer: @customer, merchant: @merchant)

			@invoice_item_1 = create(:invoice_item, status: 1, item: @item_a, invoice: @invoice_1, quantity: 10, unit_price: 10, discount_id: @discount_a.id)
			@invoice_item_2 = create(:invoice_item, status: 0, item: @item_b, invoice: @invoice_1, quantity: 5, unit_price: 20,  discount_id: @discount_a.id)

			visit merchant_bulk_discounts_path(@merchant)

			first('.buttons').click_button('Delete')

			expect(page).to have_content("#{@discount_a.name} has pending invoices, try again later.")
		end


		it 'cant be edited if it has pending invoice items', :skip_before do
			@user = create(:user, role: 1)
			@merchant = create(:merchant, user: @user)
			@customer = create(:customer, user: @user)

			@user1 = create(:user, role: 0)
			@merchant1 = create(:merchant, user: @user1)
			@customer = create(:customer, user: @user1)

			login_as(@user, scope: :user)

			@discount_a = @merchant.bulk_discounts.create!(name: "Big discount", quantity_threshold: 10, percentage: 20)
			@discount_b = @merchant.bulk_discounts.create!(name: "Big discount", quantity_threshold: 10, percentage: 35)

			@item_a = create(:item, merchant: @merchant, unit_price: 10)
			@item_b = create(:item, merchant: @merchant, unit_price: 20)

			@invoice_1 = create(:invoice, customer: @customer, merchant: @merchant)
			@invoice_2 = create(:invoice, customer: @customer, merchant: @merchant)

			@invoice_item_1 = create(:invoice_item, status: 1, item: @item_a, invoice: @invoice_1, quantity: 10, unit_price: 10, discount_id: @discount_a.id)
			@invoice_item_2 = create(:invoice_item, status: 0, item: @item_b, invoice: @invoice_1, quantity: 5, unit_price: 20,  discount_id: @discount_a.id)


			visit merchant_bulk_discounts_path(@merchant)

			first('.buttons').click_link('Edit')

			expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount_a))

			click_button "Update Bulk discount"

			expect(page).to have_content("#{@discount_a.name} has pending invoices, try again later.")
		end

	end
end
