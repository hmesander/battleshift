class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    user.create_token
    if user.save
      session[:user_id] = user.id
      Activator.inform(current_user).deliver_now
      redirect_to dashboard_path(current_user)
    else
      flash[:error] = 'Registration unsuccessful. Try again.'
      redirect_to register_path
    end
  end

  def update
    user = User.find(params[:id])
    user.active!
    if current_user.active?
      flash[:success] = 'Thank you! Your account is now activated.'
      # redirect_to dashboard_path
    end
    redirect_to dashboard_path
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :name, :password)
  end
end
