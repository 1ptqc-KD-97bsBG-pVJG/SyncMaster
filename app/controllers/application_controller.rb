class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Allow additional fields during sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    # Allow additional fields during account update
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
