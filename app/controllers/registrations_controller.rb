class RegistrationsController < Devise::RegistrationsController
  layout 'master'

  before_filter :update_sanitized_params, if: :devise_controller?

  def create
    build_resource(sign_up_params)

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, location: guest_dashboard_path
      end
    else
      clean_up_passwords resource
      render action: 'sessions/new'
    end
  end

  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :avatar, :password, :password_confirmation, :current_password) }
  end

  protected

  def update_resource(resource, params)
    if params["password"].present?
      resource.update_with_password(params)
    else
      resource.update(params.except(:current_password, :password, :password_confirmation))
    end
  end
end
