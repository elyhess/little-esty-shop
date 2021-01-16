class Merchant::BulkDiscountsController < Merchant::BaseController
  before_action :set_merchant
  before_action :set_bulk_discount, only: [:show, :destroy, :edit, :update]

  def index
    @bulk_discounts = BulkDiscount.all
  end

  def show
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    @bulk_discount = BulkDiscount.new(bulk_discount_params)
    @bulk_discount.merchant_id = params[:merchant_id]
    if @bulk_discount.save
      flash.notice = "#{@bulk_discount.name} was created successfully!"
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      render :new
    end
  end

  def update
    @bulk_discount.update(bulk_discount_params)
    flash.notice = "#{@bulk_discount.name} was updated successfully!"
    redirect_to merchant_bulk_discounts_path(@merchant, @bulk_discount)
  end

  def edit
  end

  def destroy
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def set_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end


  def bulk_discount_params
    params.require(:bulk_discount).permit(:name, :quantity_threshold, :percentage)
  end

end
