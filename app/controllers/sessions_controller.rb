class SessionsController < ApplicationController
  before_action :find_user, only: :create

  def new
    redirect_to @current_user if logged_in?
  end

  def create
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == Settings.check_box_ok ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash.now[:danger] = t ".invalid_login_message"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  # Returns user by email
  def find_user
    @user = User.find_by email: params[:session][:email].downcase
  end
end
