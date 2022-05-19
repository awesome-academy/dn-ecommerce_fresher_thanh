RSpec.shared_examples "not logged for get method" do |action|
  context "when not login" do
    before do
      sign_in nil
      get action
    end

    it "redirect login page"do
      expect(response).to redirect_to new_user_session_path
    end
  end
end

RSpec.shared_examples "not logged for other method" do
  context "when not login" do
    before do
      sign_in nil
    end

    it "redirect login page"do
      expect(response).to redirect_to new_user_session_path
    end
  end
end
