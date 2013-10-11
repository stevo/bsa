class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :initialize_gon

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to guest_dashboard_path, alert: exception.message
  end

  rescue_from IntegrityException do |exception|
    redirect_to root_path, alert: exception.message
  end

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  private

  def initialize_gon
    gon.controller_path = controller_path
    gon.action_name = action_name
  end
end
