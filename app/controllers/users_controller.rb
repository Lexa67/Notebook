class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show edit update destroy ]
  # before_action :total_price, only: [:show]
  # GET /users or /users.json
  def index
    @users = User.all.order(:name)
  end

  # GET /users/1 or /users/1.json
  def show
    @lessons = Lesson.where(user_id: @user.id).order(lesson_date: :desc)
    @lessons = @lessons.page(params[:page]).per(10)
    @total_price = 0
    @not_paid_total_price = 0

    # @lessons.each do |lesson|
    #   if lesson.paid?
    #     if lesson.not_started?
    #       @total_price += lesson.user.price
    #     end
    #   else
    #     if lesson.not_started?
    #       @not_paid_total_price += lesson.user.price
    #     end
    #   end
    # end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
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

  # PATCH/PUT /users/1 or /users/1.json
  def update
    if @user.update(user_params)
      flash[:notice] = "User was successfully updated."
      redirect_to user_path(@user)
    else
      flash[:alert] = "Error: User could not be updated."
      redirect_to user_url(@user)
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    if @user.destroy
      flash[:notice] = "User was successfully deleted."
      redirect_to users_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name)
    end  
end
