class ActivatorController < ApplicationController
  def create
    Activator.inform(current_user).deliver_now
    redirect_to dashboard_path(current_user)
  end
end
