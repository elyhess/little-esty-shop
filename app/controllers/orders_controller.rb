class OrdersController < ApplicationController
  include ActionView::Helpers::TextHelper

  def create
    # 1
    @order = Order.new(cart.contents, current_user.customer)
    redirect_to order_path(@order)
  end

  def show
    # 2
    @order = Order.new(cart.contents, current_user.customer)
  end

end
