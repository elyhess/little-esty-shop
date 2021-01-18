class Merchant::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_merchant?, except: [:show]
  helper_method :correct_merchant?

  before_action do
    redirect_to new_user_session_path unless current_user && current_user.merchant? || current_user.admin?
  end

  def correct_merchant?
    @merchant = Merchant.find(params[:merchant_id])
    render file: "/public/404" unless @merchant.user_id == current_user.id || current_user.admin?
  end
end
