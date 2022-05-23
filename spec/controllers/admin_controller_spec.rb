require "rails_helper"
require "cancan/matchers"

RSpec.describe AdminController, type: :controller do
  let!(:user) {FactoryBot.create :user}
  describe "GET index" do
    it_behaves_like "not logged for get method", "index"

    context "when not admin login" do
      subject(:ability){Ability.new(user)}
      before do
        sign_in user
        get :index
      end

      it {expect(ability).not_to be_able_to(:manage, :all)}
    end
  end
end
