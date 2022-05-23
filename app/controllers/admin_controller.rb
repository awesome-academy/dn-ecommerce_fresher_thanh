class AdminController < ApplicationController
  layout "admin"
  before_action :store_location, :authenticate_user!
  authorize_resource

  def index; end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json
      format.html{redirect_to root_path, alert: exception.message}
    end
  end
end
