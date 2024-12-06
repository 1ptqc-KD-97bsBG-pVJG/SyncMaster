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
  
    # Explicitly specify the scope and log the options
    self.resource = warden.authenticate(scope: :user, run_callbacks: false)
    Rails.logger.debug "Warden authenticate result: #{resource.inspect}"
  
    self.resource = User.find_by(email: params[:user][:email])
    if resource&.valid_password?(params[:user][:password])
      # Proceed with the Duo logic
            session[:pre_duo_auth_user_id] = resource.id
      Rails.logger.debug "Redirecting to Duo Auth page"
      render 'users/sessions/duo_auth' and return
      Rails.logger.debug "Manual authentication successful for user #{resource.email}"
    else
      Rails.logger.debug "Manual authentication failed for user #{params[:user][:email]}"
    end

    # if resource && resource.duo_enabled?
    #   Rails.logger.debug "User authenticated: #{resource.email}, Duo Enabled: #{resource.duo_enabled?}"
    #   session[:pre_duo_auth_user_id] = resource.id
    #   Rails.logger.debug "Redirecting to Duo Auth page"
    #   render 'users/sessions/duo_auth' and return
    # elsif resource.nil?
    #   Rails.logger.debug "Authentication failed; user not found or password incorrect"
    #   flash[:alert] = "Invalid email or password"
    #   redirect_to new_user_session_path and return
    # elsif !resource.duo_enabled?
    #   Rails.logger.debug "Duo not enabled for user: #{resource.email}"
    # end
  
    flash[:alert] = "You must complete two-factor authentication."
    redirect_to new_user_session_path and return
  end
end