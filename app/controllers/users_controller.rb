class UsersController < ApplicationController
  # user.role: 1 = admin, 2 = employee, 3 = customer (default)
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

    respond_to do |format|
      if @user.update(user_params)
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
    params.require(:user).permit(:name, :email, :role)
  end


end