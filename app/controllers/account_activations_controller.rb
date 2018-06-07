class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t ".acc_activated_msg"
      redirect_to user
    else
      flash[:danger] = t ".acc_activate_err_msg"
      redirect_to root_url
    end
  end
end
