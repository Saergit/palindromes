class UsersController < ApplicationController

  def show
    render json: 'Forbidden', status: :forbidden and return if params[:id].blank?

    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create!(user_params)
    if @user.save
      flash[:success] = "User was created"
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :password)
  end
end
