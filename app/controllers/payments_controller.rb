class PaymentsController < ApplicationController
	before_action :authenticate_user!

	def new
		# 4
		@order = Order.new(cart.contents, current_user.customer)
	end

	def create
		# 3
		@order = Order.new(cart.contents, current_user.customer)
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