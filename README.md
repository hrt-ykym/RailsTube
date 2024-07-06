# これなに
Railsチュートリアルで学んだ知識だけをつかって、ゼロからyoutubeを作るためのリポジトリです。

途中から口調がおかしくなるかもです。



# 環境構築
- Rubyやbundlerのインストールはできているものとする。
- gemも必要なものを適宜いれていく形にします。
- 今回はRails7.1.3.4を使用します。

## プロジェクトの開始
よし、まずはプロジェクトを作成！1番ワクワクする瞬間ですね。
```ruby
rails new railsTube --skip-test
```
後述しますが、今回はRspecを使ってテストを書くため`--skip-test` オプションを使ってRails標準であるminitest関連ファイルを作成しないようにしています。

それでははじめていきましょう！

## Rspecの導入
RailsチュートリアルにおけるテストはMinitestを使っているが、今回はRspecを使っていく。背景は以下のメリット・デメリット(出典: [RSpec基礎講座](https://zenn.dev/igaiga/books/rails-practice-note/viewer/rails_rspec_workshop))を考慮のうえRspecを選択した。

RSpec
- シェアが多く、事実上の標準
- 書いたことがあるエンジニアが多い
- 道具が豊富な反面、道具を過度につかった構造化も書けてしまう
- minitestにRSpecのガワをかぶせているので、中のコードはやや追いづらい
  
minitest
- Railsのデフォルト
- 複数DB機能など、一早く新機能が導入される
- シンプルで、道具はアドオンとして追加する方針
- シェアが少なく、書いたことがないエンジニアも多い

それではやっていこう。
まずは、以下のgemたちをGemfileに追加。
```ruby
group :development, :test do
  gem 'rspec-rails', '~> 6.1.0'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'fuubar'
end
```
Rspecの導入。
```
rails generate rspec:install
```

あ、`bundle install`や`bundle update`は適宜行なってください！

動作確認としては以下を実行し
```ruby
bundle exec rspec spec/
```
`0 examples, 0 failures` といった表示が出ればOK。

なお、毎回`bundle exec`をつけるのが面倒なので、ターミナルで以下を実行してください。
```ruby
bundle binstubs rspec-core
```
これにより、`bin/rspec` が使えるようになります。

また、`generate`コマンドを使ってモデルやコントローラーを作成すると、自動的にRSpecのテストファイルも作成されるようにするために、`RailsTube/config/application.rb`に以下を追加します。
```ruby
config.generators do |g|
  g.test_framework :rspec,
                   view_specs: false,
                   helper_specs: false,
                   routing_specs: false,
                   request_specs: false
end
```

これにて準備は完了！やっていきましょう！

# ホーム画面の作成
まずは画面に自分が作ったものが表示されて欲しいので、ホーム画面を作成します。
今回やるタスクは以下の通り。
- homeアクションを追加
  - 正しくレスポンスが返ってくること

俺たちはテスト駆動開発(TDD)をしっているので、まずはテストを書いていきます。

```ruby
rails generate rspec:request home
```
今回満たしたいのは、以下の2点
- `/home`にアクセスしたときに、HTTPステータスコード200が返ってくること
- ルート(`/`)にアクセスしたときに、HTTPステータスコード200が返ってくること


`spec/requests/home_spec.rb`
```ruby
require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /" do
    it "responds successfully with an HTTP 200 status code" do
      get root_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /home" do
    it "responds successfully with an HTTP 200 status code" do
      get home_path
      expect(response).to have_http_status(200)
    end
  end
end
```

ではこれをGreenにしていきましょう。
`config/routes.rb`に以下を追加します。
```ruby
Rails.application.routes.draw do
  root 'static_pages#home'
  get 'home', to: 'static_pages#home'
end
```
これで、`root_path`や`home_path`が使えるようになりますね。Railsチュートリアルで習いましたね！(演習問題でもあったので、忘れるはずないですよね!)

次に、コントローラーを作成します。
```ruby
rails generate controller StaticPages home
```
次にViewを作成します。
`app/views/static_pages/home.html.erb`

```html
<h1>Welcome to RailsTube!</h1>
```
これで、テストが通るはずです！TDD最高！
