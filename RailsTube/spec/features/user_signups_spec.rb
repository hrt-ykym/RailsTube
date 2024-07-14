require 'rails_helper'

RSpec.feature "UserSignups", type: :feature do
  scenario "ユーザーがサインアップする" do
    visit signup_path
    expect {
    fill_in "名前", with: "Example User"
    fill_in "Email", with: "user@example.com"
    fill_in "パスワード", with: "password"
    fill_in "パスワード確認", with: "password"
    click_button "アカウントを作成"
    }.to change(User, :count).by(1)
  end
end
