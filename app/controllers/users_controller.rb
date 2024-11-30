class UsersController < ApplicationController

  require 'net/http'
  require 'uri'
  require 'openssl'
  require 'base64'
  require 'duo_api'
  before_action :authenticate_user!

  def show
    @user = params[:id] ? User.find(params[:id]) : current_user
  end

  def index
    @users = User.all
  end

  def edit
    @user = params[:id] ? User.find(params[:id]) : current_user
  end

  def update
    @user = params[:id] ? User.find(params[:id]) : current_user
    was_duo_enabled = @user.duo_enabled?
  
    respond_to do |format|
      if @user.update(user_params)
        if @user.duo_enabled? && !was_duo_enabled
          enroll_user_in_duo(@user)
        elsif !@user.duo_enabled? && was_duo_enabled
          remove_user_from_duo(@user)
        end
        format.html { redirect_to admin_redirect_path, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  
  rescue ActionController::UnknownFormat
    # Handle unknown formats gracefully
    redirect_to admin_redirect_path, alert: "Unsupported format."
  end

  def destroy
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to users_path, notice: "User was successfully deleted." }
        format.json { head :no_content }
      else
        format.html { redirect_to root_path, alert: "User could not be deleted, please contact a developer for assistance." }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role, :duo_enabled, :otp_secret, :otp_required_for_login, :phone_number)
  end


  def enroll_user_in_duo(user)

    # Initialize the Duo API client
    client = DuoApi.new(
      Rails.application.secrets.duo_ikey,
      Rails.application.secrets.duo_skey,
      Rails.application.secrets.duo_host
    )
  
    # Make the API request to create a user
    response = client.request('POST', '/admin/v1/users', {
      username: user.email,      # Required: username of the user
      email: user.email,         # Optional: email of the user
      realname: user.name        # Optional: full name of the user
    })
  
    if response.code.to_i == 200
      user_id = JSON.parse(response.body)['response']['user_id']
      Rails.logger.info "Successfully enrolled user #{user.email} in Duo."
      user.otp_required_for_login = true
      user.save!

      # Associate a phone with the user
      phone_response = client.request('POST', '/admin/v1/phones', {
        number: user.phone_number, # Ensure `phone_number` exists in your User model
        type: 'Mobile',
        platform: 'Google Android' # or 'Google Android'
      })

      if phone_response.code.to_i == 200
        phone_id = JSON.parse(phone_response.body)['response']['phone_id']
        Rails.logger.info "Duo phone created with ID: #{phone_id}"

        # Associate the phone with the user
        associate_response = client.request('POST', "/admin/v1/users/#{user_id}/phones", {
          phone_id: phone_id
        })

        if associate_response.code.to_i == 200
          Rails.logger.info "Phone associated with user #{user.email}."
          user.update!(otp_required_for_login: true) # Enable 2FA in Rails
          Rails.logger.info "Attempted to enable 2FA for user #{user.email}."
        else
          raise "Failed to associate phone: #{associate_response.body}"
        end
      else
        raise "Failed to create phone: #{phone_response.body}"
      end
    else
      Rails.logger.error "Failed to enroll user #{user.email} in Duo: #{response.body}"
      raise "Duo enrollment failed: #{response.body}"
    end
  rescue StandardError => e
    Rails.logger.error "Exception occurred during Duo enrollment: #{e.message}"
    raise "Duo enrollment failed due to an error: #{e.message}"
  end

  def remove_user_from_duo(user)
    # Optional: Use Duo Admin API to remove the user
  end

  def admin_redirect_path
    params[:id] ? users_path : user_path
  end
end