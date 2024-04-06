class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show edit update destroy ]
  def index
    if current_user.role == "admin"
      @users = User.all.order(:name)
    else
      flash[:alert] = "You do not have access to this page!"
        redirect_to root_path
    end
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "User was successfully created."
      redirect_to users_path
    else
      flash[:alert] = "Error: User could not be created."
      redirect_to new_user_path
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "User was successfully updated."
      redirect_to user_path(@user)
    else
      flash[:alert] = "Error: User could not be updated."
      redirect_to user_url(@user)
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = "User was successfully deleted."
      redirect_to users_url
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :role)
    end  
end
