class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :micropost_of_correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t ".create_success_msg"
      redirect_to root_url
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".delete_success_msg"
    else
      flash[:danger] = t ".delete_failed_msg"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def micropost_of_correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return unless @micropost.nil?
    flash[:danger] = t ".wrong_user"
    redirect_to root_url
  end
end
