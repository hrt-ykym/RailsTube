require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(name: "Example User", email: "user@example.com", password: "password", password_confirmation: "password")
  end

  describe "ユーザーが有効であるとき" do
    it "validを適用するとtrue" do
      expect(@user).to be_valid
    end

    it "名前が存在している" do
      @user.name = "     "
      expect(@user).to_not be_valid
    end

    it "メールアドレスが存在している" do
      @user.email = "     "
      expect(@user).to_not be_valid
    end

    it "名前が30文字以内である" do
      @user.name= "a" * 31
      expect(@user).to_not be_valid
    end

    it "メールアドレスが255文字以内である" do
      @user.email = "a" * 244 + "@example.com"
      expect(@user).to_not be_valid
    end

    it "メールアドレスがユニークである" do
      duplicate_user = @user.dup
      @user.save # この時点で@userがデータベースに保存される
      expect(duplicate_user).to_not be_valid
    end

    it "メールアドレスが小文字で保存される(大文字小文字を区別しない)" do
      @user.email = "Example@example.com"
      @user.save
      expect(@user.email).to eq("example@example.com")
    end

    it "パスワードが存在している" do
      @user.password = @user.password_confirmation = " " * 6
      expect(@user).to_not be_valid
    end

    it "パスワードが6文字以上である" do
      @user.password = @user.password_confirmation = "a" * 5
      expect(@user).to_not be_valid
    end
  end

  describe "has_secure_passwordによって、ユーザー入力のパスワードがハッシュ化されるとき" do
    it "authenticateメソッドを使って、ユーザー入力のパスワードが正しいかどうかを確認できる" do 
      @user.save
      expect(@user).to eq(User.find_by(email: @user.email).authenticate(@user.password))
    end

    it "パスワードが違う時にはauthenticateメソッドはfalseを返す" do
      @user.save
      expect(User.find_by(email: @user.email).authenticate("wrong_password")).to eq(false)
    end
  end

end
