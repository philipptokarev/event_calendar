class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]  
  before_action :correct_user,   only: [:edit, :update]

	attr_accessor :name, :email

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @events = @user.events.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Event Calendar!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to root_url
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end 

 	private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :chat_id)
    end

    # Предфильтры

    # Подтверждает вход пользователя
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Подтверждает правильного пользователя
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end

