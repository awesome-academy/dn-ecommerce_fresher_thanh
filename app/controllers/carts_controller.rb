class CartsController < ApplicationController
  before_action :store_location
  before_action :load_products_into_cart, :total_price_into_cart, only: :show
  before_action :handle_quantity, only: :update

  def show; end

  def create
    product_id = params.dig(:session, :product_id)
    @cart.key?(product_id) ? @cart[product_id] += 1 : @cart[product_id] = 1
    flash[:success] = t "global.success.add_cart"
    redirect_to request.referer || root_path
  end

  def update
    if @new_quantity.negative?
      flash[:danger] = t "global.danger.update_cart"
    else
      @cart[params[:session][:product_id]] = @new_quantity
      flash[:success] = t "global.success.update_cart"
    end
    redirect_to request.referer || root_path
  end

  def destroy
    @cart.delete params.dig(:session, :product_id)
    flash[:success] = t "global.success.remove_product_from_cart"
    redirect_to request.referer || root_path
  end

  private

  def handle_quantity
    old_quantity = @cart[params[:session][:product_id]]
    @new_quantity = params.dig(:session, :quantity)&.to_i || 1
    return if @new_quantity == old_quantity
  end
end
