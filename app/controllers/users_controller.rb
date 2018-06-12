class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :load_user, except: %i(index new create)

  def index
    @users = User.paginate page: params[:page]
  end

  def show
    @microposts = @user.microposts.newest.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".check_email_msg"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".profile_updated_msg"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    flash[:success] = if @user.destroy
                        t ".user_deleted_msg"
                      else
                        t ".user_delete_err_msg"
                      end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end

  # Confirms an admin user.
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  # Load user from id
  def load_user
    @user = User.find_by id: params[:id]
    redirect_to root_url if @user.nil?
  end
end
