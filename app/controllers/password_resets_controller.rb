class PasswordResetsController < ApplicationController
  before_action :load_user, only: %i(edit update)
  before_action :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t ".reset_email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t ".email_not_found_msg"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(".pwd_empty_err")
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = t ".pwd_reset_success_msg"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email].downcase
    return unless @user.nil?
    flash[:danger] = t ".user_not_found_msg"
    redirect_to root_url
  end

  def valid_user
    return if @user && @user.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t ".pwd_link_expired"
    redirect_to new_password_reset_url
  end
end
