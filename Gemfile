source "https://rubygems.org"

gem "rails", "~> 8.0.0", ">= 8.0.0.1"

gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "mailgun-ruby"
gem "good_job", "~> 3.0"
gem "faker"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails", "~> 6.0"
  gem "pry"
  gem "factory_bot_rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver" # Optional, for using Selenium with Capybara
  gem "webdrivers" # Optional, for automatically managing WebDriver binaries
  gem "launchy"
  gem "database_cleaner-active_record"
  gem "shoulda-matchers"
end
