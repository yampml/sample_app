class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    if @user.nil?
      flash[:danger] = t ".user_not_found"
      redirect_to users_url
    else
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    end
  end

  def destroy
    relation = Relationship.find_by id: params[:id]
    if relation.nil?
      redirect_to request.referer
    else
      @user = Relationship.find_by(id: params[:id]).followed
      if @user.nil?
        flash[:danger] = t ".user_not_found"
        redirect_to users_url
      else
        current_user.unfollow @user
        respond_to do |format|
          format.html{redirect_to @user}
          format.js
        end
      end
    end
  end
end
