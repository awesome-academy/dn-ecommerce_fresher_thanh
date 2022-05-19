require "rails_helper"

RSpec.describe Admin::ProductsController, type: :controller do
  let!(:admin) {FactoryBot.create :user, role: 1}
  let!(:category) {FactoryBot.create :category}
  let!(:product_1) {FactoryBot.create :product, category_id: category.id}
  let!(:product_2) {FactoryBot.create :product, category_id: category.id}
  let!(:product_3) {FactoryBot.create :product, category_id: category.id}

  describe "GET index" do
    it_behaves_like "not logged for get method", "index"

    context "when admin logged" do
      before do
        sign_in admin
        get :index
      end

      it "show index page" do
        expect(assigns(:products)).to eq([product_3, product_2, product_1])
      end
    end
  end
end
