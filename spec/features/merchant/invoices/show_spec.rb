require 'rails_helper'

RSpec.describe 'merchants invoices index page', type: :feature do
  describe 'as a merchant' do
    before(:each) do
      Merchant.destroy_all
      Customer.destroy_all
      Transaction.destroy_all
      Invoice.destroy_all
      User.destroy_all

      @user = create(:user, role: 0)
      @merchant = create(:merchant, user: @user)
      @discount_a = @merchant.bulk_discounts.create!(name: "Big discount", quantity_threshold: 2, percentage: 20)

      @user1 = create(:user, role: 0)
      @customer_1 = create(:customer, user: @user1)
      @invoice_1 = create(:invoice, merchant: @merchant, customer: @customer_1)
      @invoice_2 = create(:invoice, merchant: @merchant, customer: @customer_1)
      create(:transaction, result: 1, invoice: @invoice_1)
      create(:transaction, result: 1, invoice: @invoice_2)

      @user2 = create(:user, role: 0)
      @customer_2 = create(:customer, user: @user2)
      @invoice_3 = create(:invoice, merchant: @merchant, customer: @customer_2)
      @invoice_4 = create(:invoice, merchant: @merchant, customer: @customer_2)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_3)
      create(:transaction, result: 1, invoice: @invoice_4)

      @user3 = create(:user, role: 0)
      @customer_5 = create(:customer, user: @user3)
      @invoice_5 = create(:invoice, merchant: @merchant, customer: @customer_5)
      @invoice_6 = create(:invoice, merchant: @merchant, customer: @customer_5)
      create(:transaction, result: 1, invoice: @invoice_5)
      create(:transaction, result: 1, invoice: @invoice_5)
      create(:transaction, result: 1, invoice: @invoice_6)

      @user4 = create(:user, role: 0)
      @customer_4 = create(:customer, user: @user4)
      @invoice_7 = create(:invoice, merchant: @merchant, customer: @customer_4)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)
      create(:transaction, result: 1, invoice: @invoice_7)

      @user5 = create(:user, role: 0)
      @customer_3 = create(:customer, user: @user5)
      @invoice_8 = create(:invoice, merchant: @merchant, customer: @customer_3)
      create(:transaction, result: 0, invoice: @invoice_7)

      @user6 = create(:user, role: 0)
      @customer_6 = create(:customer, user: @user6)
      @invoice_9 = create(:invoice, merchant: @merchant, customer: @customer_6, created_at: '2010-03-27 14:53:59', status: :completed)
      @invoice_10 = create(:invoice, merchant: @merchant, customer: @customer_6, created_at: '2010-01-27 14:53:59')
      create(:transaction, result: 1, invoice: @invoice_9)

      create_list(:item, 3, merchant: @merchant)

      5.times do
        create(:invoice_item, item: Item.first, invoice: Invoice.all.sample, status: 2)
      end

      2.times do
        create(:invoice_item, item: Item.second, invoice: @invoice_9, status: 1)
      end
      3.times do
        create(:invoice_item, item: Item.second, invoice: @invoice_7, status: 1)
      end

      5.times do
        create(:invoice_item, item: Item.third, invoice: Invoice.all.sample, status: 0)
      end
      login_as(@user, scope: :user)
    end

    it 'can show all that merchants invoice attributes' do
      visit merchant_invoice_path(@merchant.id, @invoice_9.id)

      expect(page).to have_content(@invoice_9.id)
      expect(page).to have_content("Status: Completed")
      expect(page).to have_content(@invoice_9.date)
    end

    it 'can show customer info for invoice' do
      visit merchant_invoice_path(@merchant.id, @invoice_9.id)

      expect(page).to have_content(@invoice_9.customer_name)
    end

    it 'can show my items on the invoice' do
      visit merchant_invoice_path(@merchant.id, @invoice_9.id)
      invoice_item = @invoice_9.invoice_items.first
      expect(page).to have_content("#{invoice_item.item.name}")
      expect(page).to have_content("#{invoice_item.quantity}")
      expect(page).to have_content("#{invoice_item.unit_price}")
    end

    it 'can show total revenue for that invoice' do
      visit merchant_invoice_path(@merchant.id, @invoice_9.id)
      expect(page).to have_content("Total Revenue: $#{@invoice_9.total_revenue.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}")
    end

    it 'can show total revenue for that invoice with bulk_discounts' do
      visit merchant_invoice_path(@merchant.id, @invoice_9.id)
      expect(page).to have_content("Total Revenue: $#{@invoice_9.total_revenue.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}")
    end

    it 'can enable/disable status of item' do
      visit merchant_invoice_path(@merchant.id, @invoice_9.id)
      within("#status-#{@invoice_9.invoice_items.first.id}") do
        select("Pending", from: "invoice_item[status]")
        click_button "Submit"

        expect(@invoice_9.invoice_items.first.status).to eq("pending")
      end
    end

      it 'I see a link to the bulk_discounts applied to each invoice item' do
        visit merchant_invoice_path(@merchant.id, @invoice_9.id)

        first(:link, "Big discount").click

        expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount_a))
      end

  end
end
