# これなに
Railsだけをつかって、ゼロからyoutubeを作るためのリポジトリです。


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