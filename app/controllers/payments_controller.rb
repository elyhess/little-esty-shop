class PaymentsController < ApplicationController
	before_action :authenticate_user!

	def new
		@order = Order.new(cart.contents, current_user.customer)
		@all_invoice_items = Order.all_invoice_items
	end

	def create
		@order = Order.new(cart.contents, current_user.customer)
		@all_invoice_items = Order.all_invoice_items
		@result = Braintree::Transaction.sale(amount: @order.total,
		                                      payment_method_nonce: params[:payment_method_nonce])
		if @result.success?
			session.delete(:cart)
			redirect_to root_url, notice: "Congratulations! Your transaction was successful."
		else
			flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
			render :new
		end
	end
end