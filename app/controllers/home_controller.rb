class HomeController < ApplicationController
  def index
    products = @search.result.includes(:category).newest
    @pagy, @products = pagy(products, items: Settings.pagy_item_8)
    respond_to do |format|
      format.html
      format.js
    end
  end
end
