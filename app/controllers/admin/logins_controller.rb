class Admin::LoginsController < ApplicationController
  expose(:forum) { Forum.find(params[:forum_id]) }
  def create

    login_post = Curl::Easy.http_post(forum.login_url,
      Curl::PostField.content('username', forum.user),
      Curl::PostField.content('password', forum.password),
      Curl::PostField.content('login', 'Zaloguj'))
    logger.debug login_post.body_str
    render inline: login_post.body_str
  end
end