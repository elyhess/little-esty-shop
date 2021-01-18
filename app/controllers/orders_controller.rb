class OrdersController < ApplicationController
  include ActionView::Helpers::TextHelper

  def create
    @order = Order.new(cart.contents, current_user.customer)
    @order.invoices
    @order.invoice_items
    redirect_to order_path(@order)
  end

  def show
    @order = Order.new(cart.contents, current_user.customer)
    @invoices = @order.invoices
    @invoice_items = @order.invoice_items
  end
end
