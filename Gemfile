source "https://yoomee:wLjuGMTu30AvxVyIrq3datc73LVUkvo@gems.yoomee.com"
source 'http://rubygems.org'

gem 'rails', '~> 3.1.0'
gem 'mysql2'


gem 'jquery-rails'
gem "rake", "0.8.7"
gem 'exception_notification', "2.6.1", git:'git://github.com/alanjds/exception_notification.git'
gem "country-select"
gem "formtastic-bootstrap", :git => "git://github.com/cgunther/formtastic-bootstrap.git", :branch => "bootstrap-2"
gem 'activemerchant', :require => 'active_merchant'
gem "stamp"
gem "xeroizer"
gem "delayed_job_active_record"
gem "daemons"
gem "haml"
gem "dragonfly", "~> 0.9.12"
gem 'squeel'
gem "cocoon"

gem "ym_core", "~>0.1.70"           #, :path => "~/Rails/Gems/ym_core"
gem "ym_cms", "0.3.7"   #, :path => "~/Rails/Gems/ym_cms"
gem "ym_users", "0.1.25"          #, :path => "~/Rails/Gems/ym_users"
gem "ym_permalinks"     #, :path => "~/Rails/Gems/ym_permalinks"
gem 'ym_snippets',     "~> 0.1.3"     #, :path => "~/Rails/Gems/ym_snippets"
gem 'ym_enquiries',    "~> 0.1.3"     #, :path => "~/Rails/Gems/ym_enquiries"

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
  gem "binding_of_caller"
  gem "engineyard-recipes"
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
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'sqlite3'
  gem 'timecop'
  # gem 'rb-inotify', '~> 0.8.8', :require => false if RUBY_PLATFORM =~ /darwin/i
end