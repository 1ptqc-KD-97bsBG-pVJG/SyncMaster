class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
  end
  
  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    was_duo_enabled = @user.duo_enabled?

    respond_to do |format|
      if @user.update(user_params)
        if @user.duo_enabled? && !was_duo_enabled
          # Enroll user in Duo
          enroll_user_in_duo(@user)
        elsif !@user.duo_enabled? && was_duo_enabled
          # Remove user from Duo
          remove_user_from_duo(@user)
        end
          format.html { redirect_to '/users/index', notice: "User was successfully updated." }
          format.json { render :show, status: :ok, location: @user }
      else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    puts "Inside destroy!"
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to '/users/index', notice: "User was successfully deleted." }
        format.json { head :no_content }
      else
        format.html { redirect_to root_path, alert: "User could not be deleted, please contact a developer for assistance." }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  

  private

  def user_params
    params.require(:user).permit(:name, :email, :role, :duo_enabled)
  end

  def enroll_user_in_duo(user)
    # Optional: Use Duo Admin API to pre-enroll the user
    # For simplicity, we can let Duo auto-enroll the user on first authentication
  end

  def remove_user_from_duo(user)
    # Optional: Use Duo Admin API to remove the user
    # Be cautious with API calls and handle errors appropriately
  end
end