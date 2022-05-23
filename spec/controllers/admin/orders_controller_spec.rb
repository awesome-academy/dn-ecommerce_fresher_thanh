require "rails_helper"
require "cancan/matchers"

RSpec.describe Admin::OrdersController, type: :controller do
  let!(:admin) {FactoryBot.create :user, role: 1}
  let!(:user) {FactoryBot.create :user}
  let!(:order_1) {FactoryBot.create :order, user_id: user.id}
  let!(:order_2) {FactoryBot.create :order, user_id: user.id}
  let!(:order_3) {FactoryBot.create :order, user_id: user.id, status: 2}
  let!(:order_4) {FactoryBot.create :order, user_id: user.id, status: 3}

  describe "GET index" do
    it_behaves_like "not logged for get method", "index"

    context "when not admin logged in" do
      subject(:ability){Ability.new(user)}
      before do
        sign_in user
        get :index
      end

      it {expect(ability).not_to be_able_to(:manage, :all)}
    end

    context "when admin logged" do
      before do
        sign_in admin
        get :index
      end

      it "return delivering orders" do
        expect(assigns(:delivering_orders)).to eq([order_3])
      end

      it "return received orders" do
        expect(assigns(:received_orders)).to eq([order_4])
      end

      it "return pending orders" do
        expect(assigns(:pending_orders)).to eq([order_1, order_2])
      end

      it "return all orders" do
        expect(assigns(:orders)).to eq([order_4, order_3, order_2, order_1])
      end
    end
  end

  describe "DELETE destroy" do
    let!(:category) {FactoryBot.create :category}
    let!(:product_1) {FactoryBot.create :product, category_id: category.id}
    let!(:order_detail_1) {FactoryBot.create :order_detail, order_id: order_1.id, product_id: product_1.id}
    it_behaves_like "not logged for other method" do
      before do
        delete :destroy, params: {id: order_1.id}
      end
    end

    context "when admin logged" do
      before do
        sign_in admin
      end

      context "find order by id" do
        context "order found" do
          before do
            delete :destroy, params: {
              id: order_1.id
            }
          end

          context "check order status is pending" do
            before do
              @stock = order_detail_1.product.stock
              @stock += order_detail_1.quantity
            end

            it "restore quantity" do
              expect(product_1.stock).to eq(@stock)
            end
          end

          context "check order status is not pending" do
            before do
              delete :destroy, params: {id: order_3.id}
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

          delete :destroy, params: {id: order_1.id}
        end

        it "show flash danger" do
           expect(flash[:danger]).to eq I18n.t("global.danger.destroy_danger")
        end
      end
    end
  end

  describe "PATCH update" do
    it_behaves_like "not logged for other method" do
      before do
        patch :update, params: {
          order: {status: "delivering"},
          id: order_1.id
        }
      end
    end

    context "when admin logged" do
      before do
        sign_in admin
      end

      context "find order by id" do
        context "when farams order is empty" do
          before do
            patch :update, params: {
              order: nil,
              id: order_1.id
            }
          end

          it "show flash danger" do
            expect(flash[:danger]).to eq I18n.t("global.danger.not_order")
          end
        end

        context "order found" do
          before do
            patch :update, params: {
              order: {status: "delivering"},
              id: order_1.id
            }
          end

          it "return order" do
            expect(assigns(:order)).to eq order_1
          end

          context "update status order success" do
            it "show flash success" do
              expect(flash[:success]).to eq I18n.t("global.success.update_status_order")
            end

            it "redirect to admin orders path" do
              expect(response).to redirect_to admin_orders_path
            end
          end
        end

        context "order not found" do
          before do
            patch :update, params: {
              order: {status: "delivering"},
              id: -1
            }
          end

          it "show flash danger" do
            expect(flash[:danger]).to eq I18n.t("admin.orders.not_found")
          end
        end
      end

      context "when update raise exception" do
        before do
          allow_any_instance_of(Order).to receive(:update!).and_raise(ActiveRecord::RecordNotSaved)

          patch :update, params: {
            order: {status: "delivering"},
            id: order_1.id
          }
        end

        it "show flash danger" do
           expect(flash[:danger]).to eq I18n.t("global.danger.update_status_order")
        end
      end
    end
  end
end

