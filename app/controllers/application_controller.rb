class ApplicationController < ActionController::Base
  include CartsHelper
  include OrdersHelper
  include Pagy::Backend
  rescue_from Pagy::OverflowError, with: :redirect_to_last_page

  before_action :set_locale, :init_cart, :load_cart, :load_categories,
                :query_product

  before_action :configure_permitted_parameters, if: :devise_controller?

  def store_location
    if request.path != "/users/sign_in" && request.path != "/users/sign_up" &&
       request.path != "/users/sign_out" && !request.xhr? && !current_user
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for _resource
    previous_path = session[:previous_url]
    session[:previous_url] = nil
    if current_user.admin?
      previous_path || admin_index_path
    else
      previous_path || root_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def redirect_to_last_page exception
    redirect_to url_for(page: exception.pagy.last)
  end

  def load_categories
    @categories = Category.newest
  end

  def query_product
    @search = Product.ransack(params[:q])
  end
end
