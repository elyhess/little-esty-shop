class CustomersController < ApplicationController
  def show
    @customer = current_user.customer
  end
end
