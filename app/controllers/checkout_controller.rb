class CheckoutController < ApplicationController
  include ActionView::Helpers::TextHelper

  def create
    @order = Order.new(cart.contents, current_user.customer)
    @order.add_invoice_items
    redirect_to checkout_path(@order)
  end

  def show
    @order = Order.new(cart.contents, current_user.customer)
    @all_invoice_items = Order.all_invoice_items
  end

end
