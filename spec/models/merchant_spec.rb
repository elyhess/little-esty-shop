require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :user_name}
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many :discounts }
    it { should belong_to :user}
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'class methods' do
    before :each do
      @user1 = create(:user, role: 1)
      @user2 = create(:user, role: 1)
      @user3 = create(:user, role: 1)
      @user4 = create(:user, role: 1)
      @merchant = create(:merchant, status: 0, user: @user1)
      @merchant1 = create(:merchant, status: 0, user: @user2)
      @merchant2 = create(:merchant, status: 0, user: @user3)
      @merchant3 = create(:merchant, status: 1, user: @user4)
    end
    it '::enabled' do
      expect(Merchant.enabled.first.user_name).to eq(@merchant3.user_name)
    end
    it '::disabled' do
      expect(Merchant.disabled).to eq([@merchant, @merchant1, @merchant2])
    end
    it '::top_5_revenue' do
      @user5 = create(:user, role: 1)
      @user6 = create(:user, role: 1)
      @user7 = create(:user, role: 1)
      @user8 = create(:user, role: 1)
      merchant4 = create(:merchant, user_name: '4', user: @user5)
      merchant5 = create(:merchant, user_name: '5', user: @user6)
      merchant6 = create(:merchant, user_name: '6', user: @user7)
      merchant7 = create(:merchant, user_name: '7', user: @user8)
      @user43 = create(:user, role: 1)
      customer1 = create(:customer, user: @user43)

      invoice1 = create(:invoice, customer: customer1, merchant: @merchant1)
      invoice2 = create(:invoice, customer: customer1, merchant: @merchant2)
      invoice3 = create(:invoice, customer: customer1, merchant: @merchant3)
      invoice4 = create(:invoice, customer: customer1, merchant: merchant4)
      invoice5 = create(:invoice, customer: customer1, merchant: merchant5)
      invoice6 = create(:invoice, customer: customer1, merchant: merchant6)
      invoice7 = create(:invoice, customer: customer1, merchant: merchant7)

      transaction1 = create(:transaction, invoice: invoice1, result: 1)
      transaction2 = create(:transaction, invoice: invoice2, result: 1)
      transaction3 = create(:transaction, invoice: invoice3, result: 1)
      transaction4 = create(:transaction, invoice: invoice4, result: 1)
      transaction5 = create(:transaction, invoice: invoice5, result: 1)
      transaction6 = create(:transaction, invoice: invoice6, result: 1)
      transaction7 = create(:transaction, invoice: invoice7, result: 0)

      item1 = create(:item, merchant: @merchant1)
      item2 = create(:item, merchant: @merchant2)
      item3 = create(:item, merchant: @merchant3)
      item4 = create(:item, merchant: merchant4)
      item5 = create(:item, merchant: merchant5)
      item6 = create(:item, merchant: merchant6)
      item7 = create(:item, merchant: merchant7)

      invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, quantity: 1, unit_price: 300) #300 rev
      invoice_item2 = create(:invoice_item, item: item2, invoice: invoice2, quantity: 2, unit_price: 15) #30 rev
      invoice_item3 = create(:invoice_item, item: item3, invoice: invoice3, quantity: 2, unit_price: 40) # 80 rev
      invoice_item4 = create(:invoice_item, item: item4, invoice: invoice4, quantity: 4, unit_price: 50) # 200 rev
      invoice_item5 = create(:invoice_item, item: item5, invoice: invoice5, quantity: 10, unit_price: 10) # 100 rev
      invoice_item6 = create(:invoice_item, item: item6, invoice: invoice6, quantity: 4, unit_price: 30) # 120 rev
      invoice_item7 = create(:invoice_item, item: item7, invoice: invoice7, quantity: 10, unit_price: 5) # 50 rev
      invoice_item8 = create(:invoice_item, item: item7, invoice: invoice7, quantity: 1, unit_price: 110) # 110 rev

      expect(Merchant.top_5_merchants).to eq([@merchant1, merchant4, merchant6, merchant5, @merchant3])
    end
  end

  describe 'instance methods' do
    describe 'environment for top 5 customers and ready-to-ship' do
      before :each do
        @user9 = create(:user, role: 1)
        @merchant = create(:merchant, user: @user9)

        @user43 = create(:user, role: 1)
        @customer_1 = create(:customer, user: @user43)
        @invoice_1 = create(:invoice, merchant: @merchant, customer: @customer_1)
        @invoice_2 = create(:invoice, merchant: @merchant, customer: @customer_1)
        create(:transaction, result: 1, invoice: @invoice_1)
        create(:transaction, result: 1, invoice: @invoice_2)

        @user44 = create(:user, role: 1)
        @customer_2 = create(:customer, user: @user44)
        @invoice_3 = create(:invoice, merchant: @merchant, customer: @customer_2)
        @invoice_4 = create(:invoice, merchant: @merchant, customer: @customer_2)
        create(:transaction, result: 1, invoice: @invoice_3)
        create(:transaction, result: 1, invoice: @invoice_3)
        create(:transaction, result: 1, invoice: @invoice_3)
        create(:transaction, result: 1, invoice: @invoice_4)

        @user45 = create(:user, role: 1)
        @customer_5 = create(:customer, user: @user45)
        @invoice_5 = create(:invoice, merchant: @merchant, customer: @customer_5)
        @invoice_6 = create(:invoice, merchant: @merchant, customer: @customer_5)
        create(:transaction, result: 1, invoice: @invoice_5)
        create(:transaction, result: 1, invoice: @invoice_5)
        create(:transaction, result: 1, invoice: @invoice_6)

        @user46 = create(:user, role: 1)
        @customer_4 = create(:customer, user: @user46)
        @invoice_7 = create(:invoice, merchant: @merchant, customer: @customer_4)
        create(:transaction, result: 1, invoice: @invoice_7)
        create(:transaction, result: 1, invoice: @invoice_7)
        create(:transaction, result: 1, invoice: @invoice_7)
        create(:transaction, result: 1, invoice: @invoice_7)
        create(:transaction, result: 1, invoice: @invoice_7)

        @user47 = create(:user, role: 1)
        @customer_3 = create(:customer, user: @user47)
        @invoice_8 = create(:invoice, merchant: @merchant, customer: @customer_3)
        create(:transaction, result: 0, invoice: @invoice_7)

        @user48 = create(:user, role: 1)
        @customer_6 = create(:customer, user: @user48)
        @invoice_9 = create(:invoice, merchant: @merchant, customer: @customer_6)
        @invoice_10 = create(:invoice, merchant: @merchant, customer: @customer_6)
        create(:transaction, result: 1, invoice: @invoice_9)

        create_list(:item, 3, merchant: @merchant)

        5.times do
          create(:invoice_item, item: Item.first, invoice: Invoice.all.sample, status: 2)
        end

        5.times do
          create(:invoice_item, item: Item.second, invoice: Invoice.all.sample, status: 1)
        end

        5.times do
          create(:invoice_item, item: Item.third, invoice: Invoice.all.sample, status: 0)
        end
      end
      it '#top_5_customers' do
        expect(@merchant.customers.count).to eq(10)
        top = [@customer_4.first_name, @customer_2.first_name, @customer_5.first_name, @customer_1.first_name, @customer_6.first_name]
        actual = @merchant.top_5.map { | x | x[:first_name]}
        expect(actual).to eq(top)
      end

      it '#ready_to_ship' do
        expected = @merchant.ready_to_ship
        expect(expected.length).to eq(10)
      end

      it '#best_day', :skip_before do
        @user = create(:user, role: 1)
        @merchant = create(:merchant, user: @user)
        @user50 = create(:user, role: 1)
        @customer_1 = create(:customer, user: @user50)
        @item_1 = create(:item, merchant: @merchant)

        @invoice_1 = create(:invoice, customer: @customer_1, merchant: @merchant, status: 0, created_at: "2012-01-25 09:54:09")
        @invoice_2 = create(:invoice, customer: @customer_1, merchant: @merchant, status: 1, created_at: "2012-02-25 09:54:09")
        @invoice_3 = create(:invoice, customer: @customer_1, merchant: @merchant, status: 2, created_at: "2012-03-25 09:54:09")

        @transaction1 = create(:transaction, invoice: @invoice_1, result: 1)
        @transaction2 = create(:transaction, invoice: @invoice_2, result: 1)
        @transaction3 = create(:transaction, invoice: @invoice_3, result: 1)

        @invoice_item_1 = create(:invoice_item, status: 0, item: @item_1, invoice: @invoice_1, unit_price: 300, quantity: 1)
        @invoice_item_2 = create(:invoice_item, status: 0, item: @item_1, invoice: @invoice_2, unit_price: 100, quantity: 1)
        @invoice_item_3 = create(:invoice_item, status: 0, item: @item_1, invoice: @invoice_3, unit_price: 200, quantity: 1)

        expect(@merchant.best_day).to eq(@invoice_1.date)
      end

      it '#top_5_items', :skip_before do
        @user = create(:user, role: 1)
        @merchant_2 = create(:merchant, user: @user)
        @user51 = create(:user, role: 1)
        @customer_23 = create(:customer, user: @user51)
        @invoice_33 = create(:invoice, merchant: @merchant_2, customer: @customer_23)
        @invoice_43 = create(:invoice, merchant: @merchant_2, customer: @customer_23)
        create(:transaction, result: 1, invoice: @invoice_33)
        create(:transaction, result: 0, invoice: @invoice_43)

        create_list(:item, 6, merchant: @merchant_2)

        create(:invoice_item, item: @merchant_2.items.fourth, invoice: @invoice_33, quantity: 10, unit_price: 2)#60
        1.times do
          create(:invoice_item, item: @merchant_2.items.first, invoice: @invoice_33, quantity: 10, unit_price: 3)#30
        end

        3.times do
          create(:invoice_item, item: @merchant_2.items.second, invoice: @invoice_33, quantity: 10, unit_price: 4)#120
        end
          create(:invoice_item, item: @merchant_2.items.third, invoice: @invoice_33, quantity: 10, unit_price: 6)#60
          create(:invoice_item, item: @merchant_2.items.fifth, invoice: @invoice_33, quantity: 10, unit_price: 1)#60
        2.times do
          create(:invoice_item, item: @merchant_2.items.third, invoice: @invoice_43, quantity: 10, unit_price: 6)
        end

        expected = [@merchant_2.items.second, @merchant_2.items.third, @merchant_2.items.first, @merchant_2.items.fourth, @merchant_2.items.fifth]
        expect(@merchant_2.top_5_items).to eq(expected)
      end
    end
  end
end
