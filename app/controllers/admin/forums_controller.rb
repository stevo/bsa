class Admin::ForumsController < ApplicationController
  layout 'master'
  expose(:forums, attributes: :permitted_params)
  expose(:forum, attributes: :permitted_params)

  def update
    if forum.save
      redirect_to admin_forums_path
    else
      render :edit
    end
  end

  private
  def permitted_params
    params.require(:forum).permit(:name, :url, :login_url, :meeting_url, :state, :user, :password)
  end
end
