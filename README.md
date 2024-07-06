# これなに
Railsだけをつかって、ゼロからyoutubeを作るためのリポジトリです。


# やるべきタスク
- [ ] いちばん手前の画面を作る
  - [ ] ホーム
  - [ ] ショート
  - [ ] 登録チャンネル
  - [ ] マイページ
  - [ ] 履歴
  - [ ] 設定
  - [ ] ヘルプ
  - [ ] ログイン
- [ ] 動画アップロード機能
- [ ] 動画再生機能

# Rspecの導入
以下をGemfileに追加。
```ruby
group :development, :test do
  gem 'rspec-rails', '~> 6.1.0'
  gem 'factory_bot_rails'
  gem 'faker'
end
```

```
rails generate rspec:install
```

テストの書き方はigaigaさんの[RSpec基礎講座の記事](https://zenn.dev/igaiga/books/rails-practice-note/viewer/rails_rspec_workshop)を参考に書いていく。

```ruby
require "rails_helper"
RSpec.describe Book, type: :model do
  describe "#.メソッド名" do
    context "○○なとき" do
      it "○○なこと" do end
      it "○○なこと" do end
    end
    context "○○なとき" do
      it "○○なこと" do end
    end
  end
  describe "#.メソッド名" do ... end
end
```