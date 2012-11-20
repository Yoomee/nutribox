source "https://yoomee:wLjuGMTu30AvxVyIrq3datc73LVUkvo@gems.yoomee.com"
source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'mysql2'


gem 'jquery-rails'
gem "rake", "0.8.7"
gem 'exception_notification', "2.6.1", git:'git://github.com/alanjds/exception_notification.git'
gem "country-select"
gem "formtastic-bootstrap", :git => "git://github.com/cgunther/formtastic-bootstrap.git", :branch => "bootstrap-2"
gem "whenever", :require => false
gem 'activemerchant', :require => 'active_merchant'
gem "stamp"

gem "ym_core"           #, :path => "~/Rails/Gems/ym_core"
gem "ym_cms"            #, :path => "~/Rails/Gems/ym_cms"
gem "ym_users"          #, :path => "~/Rails/Gems/ym_users"
gem "ym_permalinks"     #, :path => "~/Rails/Gems/ym_permalinks"
gem "ym_snippets"       #, :path => "~/Rails/Gems/ym_snippets"

group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

group :development do
  gem 'growl'
  gem 'letter_opener'
  gem 'ruby-debug19'
  gem 'ym_tools'
  gem 'passenger'
end

group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'turn', :require => false
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'sqlite3'
end