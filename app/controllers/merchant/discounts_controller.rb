class Merchant::DiscountsController < Merchant::BaseController
  before_action :set_merchant, only: [:index, :show]

  def index
    @discounts = Discount.all
  end

  def show
    @discount = Discount.find(params[:id])
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

end
