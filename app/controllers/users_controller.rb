class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash[:error] = 'Registration unsuccessful. Try again.'
      redirect_to register_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :name, :password)
  end
end
