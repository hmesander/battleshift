class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email_address: params[:email_address])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path(user)
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
