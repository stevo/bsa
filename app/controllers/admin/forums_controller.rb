class Admin::ForumsController < ApplicationController
  layout 'master'
  expose(:forums)
  expose(:forum, attributes: :permitted_params)

  def update
    if forum.save
      redirect_to admin_forums_path
    else
      render :edit
    end
  end

  def create
    if forum.save
      redirect_to admin_forums_path
    else
      render :new
    end
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
