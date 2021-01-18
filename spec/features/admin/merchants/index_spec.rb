require 'rails_helper'

RSpec.describe 'Admin Merchants Index' do
  before :each do
    @admin = create(:user, role: 1)

    @user1 = create(:user, role: 0)
    @user2 = create(:user, role: 0)
    @user3 = create(:user, role: 0)
    @user4 = create(:user, role: 0)
    @user5 = create(:user, role: 0)
    @user6 = create(:user, role: 0)
    @user7 = create(:user, role: 0)
    @user8 = create(:user, role: 0)

    @merchant_1 = create(:merchant, status: 1, user: @user7)
    @merchant_2 = create(:merchant, status: 0, user: @user1)
    @merchant_3 = create(:merchant, user: @user2)
    @merchant_4 = create(:merchant, user: @user3)
    @merchant_5 = create(:merchant, user: @user4)
    @merchant_6 = create(:merchant, user: @user5)
    @merchant_7 = create(:merchant, user: @user6)

    login_as(@admin, scope: :user)
  end
  describe 'List of Merchants' do
    it 'can show a list of each merchant in the system' do
      visit admin_merchants_path

      expect(page).to have_content(@merchant_1.user_name)
      expect(page).to have_content(@merchant_2.user_name)
      expect(page).to have_content(@merchant_3.user_name)
      expect(page).to have_content(@merchant_4.user_name)
      expect(page).to have_content(@merchant_5.user_name)
      expect(page).to have_content(@merchant_6.user_name)
      expect(page).to have_content(@merchant_7.user_name)
    end
    it 'can have show page links' do
      visit admin_merchants_path
      click_on @merchant_1.user_name

      expect(current_path).to eq(admin_merchant_path(@merchant_1))
    end
    it 'can disable and enable merchants' do
      visit admin_merchants_path

      within('#merchants-enabled') do
        expect(page).to have_content("Enabled Merchants")
        expect(page).to have_content(@merchant_1.user_name)
        first("#merchant-#{@merchant_1.id}").click_on('Disable')
        expect(page).to_not have_content(@merchant_1.user_name)
      end

      within('#merchants-disabled') do
        expect(page).to have_content("Disabled Merchants")
        expect(page).to have_content(@merchant_1.user_name)

        first("#merchant-#{@merchant_2.id}").click_on('Enable')
        expect(page).not_to have_content(@merchant_2.user_name)
      end
      within('#merchants-enabled') do
        expect(page).to have_content(@merchant_2.user_name)
      end
    end
    it 'can display top 5 merchants by revenue' do
      customer1 = create(:customer, user: @user8)

      invoice1 = create(:invoice, customer: customer1, merchant: @merchant_1)
      invoice2 = create(:invoice, customer: customer1, merchant: @merchant_2)
      invoice3 = create(:invoice, customer: customer1, merchant: @merchant_3)
      invoice4 = create(:invoice, customer: customer1, merchant: @merchant_4)
      invoice5 = create(:invoice, customer: customer1, merchant: @merchant_5)
      invoice6 = create(:invoice, customer: customer1, merchant: @merchant_6)
      invoice7 = create(:invoice, customer: customer1, merchant: @merchant_7)

      transaction1 = create(:transaction, invoice: invoice1, result: 1)
      transaction2 = create(:transaction, invoice: invoice2, result: 1)
      transaction3 = create(:transaction, invoice: invoice3, result: 1)
      transaction4 = create(:transaction, invoice: invoice4, result: 1)
      transaction5 = create(:transaction, invoice: invoice5, result: 1)
      transaction6 = create(:transaction, invoice: invoice6, result: 1)
      transaction7 = create(:transaction, invoice: invoice7, result: 0)

      item1 = create(:item, merchant: @merchant_1, unit_price: 300)
      item2 = create(:item, merchant: @merchant_2, unit_price: 15)
      item3 = create(:item, merchant: @merchant_3, unit_price: 40)
      item4 = create(:item, merchant: @merchant_4, unit_price: 50)
      item5 = create(:item, merchant: @merchant_5, unit_price: 10)
      item6 = create(:item, merchant: @merchant_6, unit_price: 30)
      item7 = create(:item, merchant: @merchant_7, unit_price: 5)

      invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, quantity: 1, unit_price: 300) #300 rev
      invoice_item2 = create(:invoice_item, item: item2, invoice: invoice2, quantity: 2, unit_price: 15) #30 rev
      invoice_item3 = create(:invoice_item, item: item3, invoice: invoice3, quantity: 2, unit_price: 40) # 80 rev
      invoice_item4 = create(:invoice_item, item: item4, invoice: invoice4, quantity: 4, unit_price: 50) # 200 rev
      invoice_item5 = create(:invoice_item, item: item5, invoice: invoice5, quantity: 10, unit_price: 10) # 100 rev
      invoice_item6 = create(:invoice_item, item: item6, invoice: invoice6, quantity: 4, unit_price: 30) # 120 rev
      invoice_item7 = create(:invoice_item, item: item7, invoice: invoice7, quantity: 10, unit_price: 5) # 50 rev
      invoice_item8 = create(:invoice_item, item: item7, invoice: invoice7, quantity: 1, unit_price: 110) # 110 rev

      visit admin_merchants_path
      within '#merchants-revenue' do
        expect(all('#merchant')[0].text).to eq("#{@merchant_1.user_name}: $300\nTop selling day was: #{@merchant_1.best_day}")
        expect(all('#merchant')[1].text).to eq("#{@merchant_4.user_name}: $200\nTop selling day was: #{@merchant_4.best_day}")
        expect(all('#merchant')[2].text).to eq("#{@merchant_6.user_name}: $120\nTop selling day was: #{@merchant_6.best_day}")
        expect(all('#merchant')[3].text).to eq("#{@merchant_5.user_name}: $100\nTop selling day was: #{@merchant_5.best_day}")
        expect(all('#merchant')[4].text).to eq("#{@merchant_3.user_name}: $80\nTop selling day was: #{@merchant_3.best_day}")
      end
    end
  end
end
