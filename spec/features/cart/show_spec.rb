require 'rails_helper'

RSpec.describe "When a user tries to checkout" do
  it "displays a message" do
    @user = create(:user, role: 0)
    @customer = create(:customer, user: @user)
    @merchant = create(:merchant, user: @user, status: 1)
    @item = create(:item, merchant: @merchant)
    @item2 = create(:item, merchant: @merchant)
    @user1 = create(:user, role: 0)
    @customer1 = create(:customer, user: @user1)
    @merchant1 = create(:merchant, user: @user1, status: 1)

    visit "/"

    within("#item-#{@item.id}") do
      click_button "Add To Cart"
    end

    within("#item-#{@item2.id}") do
      click_button "Add To Cart"
    end
    within("#item-#{@item.id}") do
      click_button "Add To Cart"
    end
    click_on "Cart (3)"

    within("#item-#{@item.id}") do
      click_on "Remove Item"
    end

    within(".level-right") do
      click_on 'Check Out'
    end

    expect(page).to have_content("Login")

    fill_in "user[email]", with: "#{@user1.email}"
    fill_in "user[password]", with: "#{@user1.password}"

    click_button "Log in"

    click_on "Cart (1)"

    within(".level-right") do
      click_on 'Check Out'
    end

    expect(page).to have_content(@merchant.invoice_items.first.item.name)
  end
end
