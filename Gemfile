source 'https://rubygems.org'
ruby '2.1.1'

gem 'rails', '4.2.0'
gem 'thin', '1.6.3'
gem 'pg', '0.17.1'

gem 'sass-rails', '5.0.1'
gem 'bootstrap-sass', '3.3.1.0'
gem 'autoprefixer-rails', '4.0.2.2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '4.1.0'
gem 'angularjs-rails', '1.3.36'
gem 'jquery-rails', '4.0.3'
gem 'jbuilder', '2.2.6'

gem 'devise'

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '1.2.0'
  gem 'spring-commands-rspec', '1.0.4'
end

group :test do
  gem 'factory_girl_rails', '4.5.0'
end

group :development, :test do
  gem 'rspec-rails', '3.1.0'
  # temp pull code from this branch since it has a few bugs fixed (pull requests #23 #24)
  gem 'protractor-rails', :git => 'https://github.com/fdibartolo/protractor-rails', :branch => 'bugfixes'
end

gem 'sdoc', '~> 0.4.0', group: :doc
