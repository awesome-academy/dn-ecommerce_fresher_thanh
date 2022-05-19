class AdminController < ApplicationController
  layout "admin"
  before_action :authenticate_user!, :check_admin

  def index; end

  private

  def check_admin
    return if current_user.admin?

    flash[:danger] = t "global.danger.not_admin"
    redirect_to root_path
  end
end
