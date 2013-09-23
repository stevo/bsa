class UnauthenticatedHandler < Devise::FailureApp
  def redirect_url
    guest_dashboard_path
  end

  def respond
    redirect
  end
end
