class Admin::ForumsController < ApplicationController
  layout 'master'
  expose(:forums)
  expose(:forum, attributes: :permitted_params)

  def update
    forum.save
    redirect_to admin_forums_path
  end

  def create
    forum.save
    redirect_to admin_forums_path
  end

  def destroy
    forum.destroy
    render :index
  end

  private
  def permitted_params
    params.require(:forum).permit(:name, :url, :login_url, :meeting_url, :state, :user, :password)
  end
end
