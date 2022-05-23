source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.7.1"

gem "active_storage_validations", "0.8.2"
gem "bcrypt", "~> 3.1", ">= 3.1.17"
gem "bootsnap", ">= 1.4.2", require: false
gem "bootstrap-sass", "3.4.1"
gem "cancancan"
gem "config"
gem "devise"
gem "faker", "~> 2.20"
gem "image_processing", "1.9.3"
gem "jbuilder", "~> 2.7"
gem "mini_magick", "4.9.5"
gem "mysql2"
gem "pagy", "~> 5.10", ">= 5.10.1"
gem "puma", "~> 4.1"
gem "rails", "~> 6.0.4", ">= 6.0.4.7"
gem "rails-i18n"
gem "ransack"
gem "sass-rails", ">= 6"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 4.0"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", "~> 5.0.0"
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
  gem "simplecov"
  gem "simplecov-rcov"
end

group :development do
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "factory_bot_rails", "~> 6.2"
  gem "rails-controller-testing", "~> 1.0", ">= 1.0.5"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 5.1"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
