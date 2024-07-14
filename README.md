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

<!-- また、`generate`コマンドを使ってモデルやコントローラーを作成すると、自動的にRSpecのテストファイルも作成されるようにするために、`RailsTube/config/application.rb`に以下を追加します。
```ruby
config.generators do |g|
  g.test_framework :rspec,
                   view_specs: false,
                   helper_specs: false,
                   routing_specs: false,
                   request_specs: false
end
``` -->

これにて準備は完了！やっていきましょう！

# ホーム画面の作成
まずは画面に自分が作ったものが表示されて欲しいので、ホーム画面を作成します。
今回やるタスクは以下の通り。
- homeアクションを追加
  - 正しくレスポンスが返ってくること

俺たちはテスト駆動開発(TDD)をしっているので、まずはテストを書いていきます。

```ruby
rails generate rspec:request static_pages
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

# ユーザー登録機能の作成
僕たちパスワードのハッシュ化や、Validationやらフォームの作成やら得意じゃないですか(きっとそう)。なので、まずはユーザー登録機能を作成していきます。


## ユーザー登録画面の作成

Testコードを書きます
```ruby
rails generate rspec:request users
```

`spec/requests/users_spec.rb`
```ruby
require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /signup" do
    it "success" do
      get signup_path
      expect(response).to have_http_status(200)
    end
  end
end
```

`config/routes.rb`に以下を追加します。
```ruby
Rails.application.routes.draw do
  root 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get '/signup', to: 'users#new'
end
```

コントローラーを作成します。ユーザー登録のために必要なCRUDのメソッドは
- `new`: 新しいリソースを作成するためのフォームを表示する役割
- `create`: フォームから送信されたデータを受け取り、新しいリソースを作成する役割
- `show`: ユーザーの詳細ページを表示する役割  

の3つのメソッドっぽいですね。
```ruby
rails generate controller Users new create show
```

コントローラーみてみると、
```ruby
class UsersController < ApplicationController
  def new
  end

  def create
  end

  def show
  end
end
```
となっているので、これでOKですね。

Viewを作成します。
`app/views/users/new.html.erb`
```html
<h1>Users#new</h1>
<p>Find me in app/views/users/new.html.erb</p>
```

これでテストが通るはず！
```ruby
bin/rspec spec
```


## モデルの作成
では、モデルの作成をしましょう。
今回、ユーザーの情報はname, email, password_digestの3つを持てばよい。
```ruby
rails generate model User name:string email:string password_digest:string
rails db:migrate
```

我々はパスワードをハッシュ化して保存する方法をしっていましたね。`bcrypt`です。以下のgemを追加してください。
```ruby
gem 'bcrypt'
```
ではモデルを書きましょう。こう言ったユーザー登録系のモデルで組み込んでおくと良いものってなんでしたっけ？
- 保存前のemailの小文字化
- パスワードのハッシュ化
- バリデーション

でしたよね。

`app/models/user.rb`
```ruby
class User < ApplicationRecord
    before_save { self.email = email.downcase }
    
    has_secure_password

    validates :name, presence: true, length: { maximum: 30 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
    validates :password, presence: true, length: { minimum: 6 }
end


```
`case_sensitive: false`は大文字小文字を区別しないようにするためのオプション。私は忘れてました...。

ところで、has_secure_passwordはどういう働きをしているんでしたっけ？
- セキュアにハッシュ化したパスワードをデータベース内の`password_digest`カラムに保存できるようになる
- `password`と`password_confirmation`の2つの仮想的な属性を追加してくれる
- ユーザーが保存したパスワードがハッシュ化されたパスワードと一致するかどうかを検証する`authenticate`メソッド(引数の文字列がパスワードと一致する場合はユーザーオブジェクトを返し、一致しない場合はfalseを返す)


ではこれを踏まえてテストコード書きましょう
```ruby
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
```
ちょっと
```ruby
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
```
の部分が個人的にスッと入ってこなかったので、もう少し説明を加えます。
- `@user.save`でデータベースに保存される
- `User.find_by(email: @user.email)`でデータベースから`@user`と同じemailを持つユーザーを取得
- `<>.authenticate(@user.password)`で`@user`のパスワードがデータベースに保存されているパスワードと一致するかどうかを確認。一致する場合にauthenticateメソッドは`@user`を返し、一致しない場合は`false`を返す


## ユーザー登録フォームの作成
ユーザー登録フォームの作成に移りましょう。まずはルーティングから。
ユーザー登録では、CRUD操作をするため、railsのresourcesメソッドを使ってルーティングを設定しましょう。

resourcesメソッドは、7つのアクションを自動的に生成してくれます。
- index: リソースの一覧を表示する
- show: 特定のリソースを表示する
- new: 新しいリソースを作成するためのフォームを表示する
- create: フォームから送信されたデータを受け取り、新しいリソースを作成する
- edit: 既存のリソースを編集するためのフォームを表示する
- update: フォームから送信されたデータを受け取り、リソースを更新する
- destroy: リソースを削除する

しかし、今回はユーザー登録フォーム画面の表示、ユーザー登録処理、ユーザー詳細画面の表示の3つのアクションしか使わないので、`only`オプションを使って、使うアクションだけを指定します。

`config/routes.rb`
```ruby
Rails.application.routes.draw do
  root 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get '/signup', to: 'users#new'
  resources :users, only: [:new, :create, :show]
end
```
これにより、
- new_user_path: ユーザー登録フォーム画面を表示する(GETリクエスト)
- users_path: ユーザー登録処理を行う (POSTリクエスト)
- user_path(id): ユーザー詳細画面を表示する (GETリクエスト)

が使えるようになります。


### newアクションの作成
登録フォームでは、MVCのコントローラーからViewに、@userというインスタンス変数でユーザー情報を渡します。そのために、`new`アクションで`User.new`のインスタンス変数を作成します。

`app/controllers/users_controller.rb`
```ruby
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
  end

  def show
  end
end
```

### ユーザー登録フォームの作成
登録フォームには、Railsの`from_with`ヘルパーメソッドがありましたね。
`app/views/users/new.html.erb`
```erb
<%= form_with(model: @user) do |f| %>
  <%= f.label(:name) %>
  <%= f.text_field(:name) %>
  <%= f.label(:email)%>
  <%= f.email_field(:email) %>
  <%= f.label(:password) %>
  <%= f.password_field(:password) %>
  <%= f.label(:password_confirmation)%>
  <%= f.password_field(:password_confirmation)%>
  <%= f.submit("Create my account")%>
<% end %>
```
自分も忘れてたので、解説しておくと、`form_with`メソッドは、引数である`model: @user`によって、`@user`を使ってフォームを作成することができます。ここでの@userは、`new`アクションで作成した`User.new`のインスタンス変数ですね。MVCコントローラを考えると、コントローラーの`new`アクションでインスタンス変数を作成して、それをViewに渡すという流れですね。

### createアクションの作成
createアクションでは、フォームから送信されたデータを受け取り、新しいユーザーを作成します。ここで注意すべき点があったのを覚えていますでしょうか。strong parametersです。`params`ハッシュからデータを取り出すときには、`permit`メソッドを使って許可された属性だけを取り出すようにしないといけないということです。`@user = User.new(params[:user])`のように書きたいところですが、`params[:user]`にはユーザーが入力した内容をUserモデルに保存するため、curlコマンドなどで送信されたデータを改ざんされると、`name`, `email`, `password`, `password_confirmation`以外の属性も保存されてしまう可能性があるんでした。この辺もちゃんと書いてあるRailsチュートリアル、すごいですね。

では、上記のことを防ぐために、user_paramsというプライベートメソッドを作成したうえで、createアクションを作成しましょう。流れとしては
- フォームから送信された`params[:user]`を受けとる(`@user=User.new(user_params)`)
- 保存に成功した場合は、ユーザー詳細ページにリダイレクト
- 保存に失敗した場合は、新規登録画面を再表示

`app/controllers/users_controller.rb`
```ruby
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
    # エラーメッセージは未実装
      redirect_to user_path(@user)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
```
ここで`user_params`メソッドを解説しておく。
- `params.require(:user)`: paramsが`user`キーを持っていることを要求する
- `<>.permit(:name, :email, :password, :password_confirmation)`: `name`, `email`, `password`, `password_confirmation`の属性だけを許可する

### showアクションの作成
ユーザー登録が成功した場合、ユーザー詳細ページを表示する必要があります。showアクションを作成しましょう。

`app/controllers/users_controller.rb`
```ruby
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # エラーメッセージは未実装
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
```

これにて、一連のユーザー登録機能の作成は完了です！テストも作成しましょう。
## ユーザー登録機能のテスト
ユーザー登録機能のテストを書きましょう。今回は以下のテストを書きます。
