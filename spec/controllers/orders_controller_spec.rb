require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  let!(:user) {FactoryBot.create :user}
  let!(:order_1) {FactoryBot.create :order, user_id: user.id}
  let!(:order_2) {FactoryBot.create :order, user_id: user.id}
  let!(:category) {FactoryBot.create :category}
  let!(:product_1) {FactoryBot.create :product, category_id: category.id}
  let!(:product_2) {FactoryBot.create :product, category_id: category.id}

  describe "GET index" do
    it_behaves_like "not logged for get method", "index"

    context "when user logged" do
      before do
        sign_in user
        get :index
      end

      context "when has orders" do
        it "load orders success" do
          expect(assigns(:orders)).to eq([order_2, order_1])
        end

        it "render index" do
          expect(response).to render_template :index
        end
      end
    end
  end

  describe "POST create" do
    it_behaves_like "not logged for other method" do
      before do
        post :create, params: {
          order: {name: "test", phone: "0123456789", address: "test"}
        }
      end
    end

    context "when user logged" do
      before do
        sign_in user
        session[:cart] = {product_1.id.to_s => 1, product_2.id.to_s => 2}
        post :create, params: {
          order: {name: "test", phone: "0123456789", address: "test"}
        }
      end

      it "build order success" do
        expect(assigns(:order)).to eq(subject.current_user.orders.last)
      end

      context "order save success" do
        it "show flash success" do
          expect(flash[:success]).to eq I18n.t("global.success.order")
        end
      end

      context "order save failed" do
        before do
          allow_any_instance_of(Order).to receive(:save!).and_raise(ActiveRecord::RecordNotSaved)

          session[:cart] = {product_1.id.to_s => 1, product_2.id.to_s => -2}
          post :create, params: {
            order: {name: "test", phone: "0123456789", address: "test"}
          }
        end
        it "show flash danger" do
           expect(flash[:danger]).to eq I18n.t("global.danger.order")
        end

        it "redirect to home page" do
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe "DELETE destroy" do
    let!(:order_pending_1) {FactoryBot.create :order, user_id: user.id, status: 0}
    let!(:order_not_pending) {FactoryBot.create :order, user_id: user.id, status: 2}
    let!(:product_1) {FactoryBot.create :product, category_id: category.id}
    let!(:order_detail_1) {FactoryBot.create :order_detail, order_id: order_pending_1.id, product_id: product_1.id}

    it_behaves_like "not logged for other method" do
      before do
        delete :destroy, params: {id: order_pending_1.id}
      end
    end

    context "when user logged" do
      before do
        sign_in user
      end

      context "find order by id" do
        context "order found" do
          before do
            delete :destroy, params: {id: order_pending_1.id}
          end

          it "return order" do
            expect(assigns(:order)).to eq order_pending_1
          end

          context "order status is pending" do
            before do
              @stock = order_detail_1.product.stock
              @stock += order_detail_1.quantity
            end

            it "restore quantity" do
              expect(product_1.stock).to eq(@stock)
            end
          end

          context "order status is not pending" do
            before do
              delete :destroy, params: {id: order_not_pending.id}
            end

            it "show flash danger" do
              expect(flash[:danger]).to eq I18n.t("global.danger.pending_deleted")
            end
          end
        end

        context "order not found" do
          before do
            delete :destroy, params: {id: -1}
          end

          it "show flash danger" do
            expect(flash[:danger]).to eq I18n.t("admin.orders.not_found")
          end
        end
      end

      context "when update raise exception" do
        before do
          allow_any_instance_of(Order).to receive(:update!).and_raise(ActiveRecord::RecordNotSaved)

          delete :destroy, params: {id: order_pending_1.id}
        end

        it "show flash danger" do
           expect(flash[:danger]).to eq I18n.t("global.danger.destroy_danger")
        end
      end
    end
  end
end
