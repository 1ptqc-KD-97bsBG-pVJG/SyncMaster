class Users::SessionsController < Devise::SessionsController
  prepend_before_action :authenticate_with_duo, only: [:create]

  def create
    puts "create method called"
    super
  end

  def duo_auth
    Rails.logger.debug "Duo Auth page for user: #{session[:pre_duo_auth_user_id]}"
  
    @user = User.find(session[:pre_duo_auth_user_id])
    @sig_request = Duo.sign_request(
      ENV['DUO_IKEY'],
      ENV['DUO_SKEY'],
      ENV['DUO_AKEY'],
      @user.email
    )
  
    Rails.logger.debug "Generated Duo Sig Request: #{@sig_request}"
  end

  def duo_verify
    Rails.logger.debug "Duo Verification started"
  
    duo_sig_response = params[:sig_response]
    authenticated_username = Duo.verify_response(
      ENV['DUO_IKEY'],
      ENV['DUO_SKEY'],
      ENV['DUO_AKEY'],
      duo_sig_response
    )
  
    if authenticated_username
      Rails.logger.debug "Duo Authentication successful for: #{authenticated_username}"
  
      user = User.find_by(email: authenticated_username)
      sign_in(user)
      session[:pre_duo_auth_user_id] = nil
      redirect_to after_sign_in_path_for(user)
    else
      Rails.logger.debug "Duo Authentication failed"
      
      session[:pre_duo_auth_user_id] = nil
      flash[:alert] = "Two-factor authentication failed."
      redirect_to new_user_session_path
    end
  end

  private

  def authenticate_with_duo
    Rails.logger.debug "authenticate_with_duo called for user"
  
    # Authenticate the user with Devise
    self.resource = warden.authenticate(auth_options)
  
    if resource
      Rails.logger.debug "User authenticated: #{resource.email}, Duo Enabled: #{resource.duo_enabled?}"
  
      if resource.duo_enabled?
        Rails.logger.debug "Redirecting to Duo for user: #{resource.email}"
  
        session[:pre_duo_auth_user_id] = resource.id
        redirect_to duo_auth_path and return
      end
    end
  
    # If no resource is found or Duo isn't enabled
    if resource.nil? || !resource.duo_enabled?
      Rails.logger.debug "2FA required but failed; denying access"
      flash[:alert] = "You must complete two-factor authentication."
      redirect_to new_user_session_path and return
    end

  
    # If no resource is found or Duo isn't enabled, fallback to normal behavior
    Rails.logger.debug "No 2FA required; proceeding with standard login"
  end
end