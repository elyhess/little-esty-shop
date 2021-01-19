class OrdersController < ApplicationController
  include ActionView::Helpers::TextHelper

  def create
    @order = Order.new(cart.contents, current_user.customer)
    redirect_to order_path(@order)
  end

  def show
    @order = Order.new(cart.contents, current_user.customer)
    @invoice_items = @order.invoice_items
  end

  def update
    @order = Order.new(cart.contents, current_user.customer)
    @order.invoices.first.update(status: 2)
    session.delete(:cart)
    redirect_to root_path
  end
end
