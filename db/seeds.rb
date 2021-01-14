# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


InvoiceItem.destroy_all
Item.destroy_all
Transaction.destroy_all
Invoice.destroy_all
Customer.destroy_all
Merchant.destroy_all
User.destroy_all

@user = FactoryBot.create(:user, role: 1, email: "admin@example.com", password: "password", password_confirmation: "password")

@user1 = FactoryBot.create(:user, role: 0, user_name: "me", email: "merchant@example.com", password: "password", password_confirmation: "password")
@merchy = FactoryBot.create(:merchant, user_name: @user1.user_name, user: @user1)

5.times do
	FactoryBot.create(:discount, merchant: @merchy)
end

20.times do
  @user = FactoryBot.create(:user, role: 0)
  @merchant = FactoryBot.create(:merchant, user_name: @user.user_name, user: @user)
  10.times do
    FactoryBot.create(:item, merchant: @merchant)
  end
  @user2 = FactoryBot.create(:user)
  @customer = FactoryBot.create(:customer, first_name: @user2.first_name, last_name: @user2.last_name, user: @user2)
  5.times do
    Invoice.create(status: Faker::Number.between(from: 0, to: 2), merchant: @merchant, customer: @customer)
  end
end


5.times do
  Invoice.all.each do |invoice|
    item = invoice.merchant.items.sample
    FactoryBot.create(:invoice_item, invoice: invoice, item: item, unit_price: item.unit_price)
    FactoryBot.create(:transaction, invoice: invoice)
  end
end
