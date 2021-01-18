require 'rails_helper'

RSpec.describe "When a user adds items to their cart" do
  it "displays a message" do
    @user = create(:user, role: 0)
    @merchant = create(:merchant, user: @user, status: 1)
    @item = create(:item, merchant: @merchant)
    @item2 = create(:item, merchant: @merchant)

    login_as @user

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
    within("#item-#{@item2.id}") do
      expect(page).to have_content("#{@item2.name}")
    end

    expect(page).to have_content("#{@item.name} has been removed from your cart.")
  end
end
