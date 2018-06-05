class SessionsController < ApplicationController
  def new
    redirect_to @current_user if logged_in?
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = t ".invalid_login_message"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
