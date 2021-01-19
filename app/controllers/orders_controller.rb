class OrdersController < ApplicationController
  include ActionView::Helpers::TextHelper

  def create
    @order = Order.new(cart.contents, current_user.customer)
    redirect_to order_path(@order)
  end

  def show
    require "pry"; binding.pry
    @order = Order.new(cart.contents, current_user.customer)
  end

end
