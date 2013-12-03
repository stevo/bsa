class Admin::ForumsController < ApplicationController
  layout 'master'
  expose(:forums, attributes: :permitted_params)
  expose(:forum, atrributes: :permitted_params)

  def update
    params[:forum].each { |f| forum[f[0]] = f[1] }
    if forum.save
      redirect_to admin_forums_path
    else
      render :edit
    end
  end

  public
  def permitted_params
    params.permit(:name, :url, :login_url, :meeting_url, :state, :user, :password)
  end
end