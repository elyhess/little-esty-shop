class Merchant::BaseController < ApplicationController
  before_action :authenticate_user!

  before_action do
    redirect_to new_user_session_path unless current_user && current_user.merchant? || current_user.admin?
  end

end
