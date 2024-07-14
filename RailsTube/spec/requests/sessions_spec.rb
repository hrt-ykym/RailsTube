require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "returns http success" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /login" do
    before do
      @user = User.create(name: "Example User", email: "user@example.com", password: "password", password_confirmation: "password")
    end
    it "ログイン成功" do
      post login_path, params: { session: { email: @user.email, password: @user.password } }
      expect(response).to redirect_to(@user)
    end

    it "ログイン失敗" do
      post login_path, params: { session: { email: "invalid", password: "wrong" } }
      expect(response.body).to include('Invalid email/password combination')
    end
  end
end
