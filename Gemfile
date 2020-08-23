# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 4'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

gem 'bcrypt'
gem 'config'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'httparty'
gem 'trailblazer-rails'

gem 'reform'
gem 'reform-rails'
# gem 'dry-validation'

# API
gem 'grape'
gem 'grape-entity'
gem 'jwt'
gem 'oj'
# HINT: latest knock compatible with zeitwerk
gem 'knock', github: 'nsarno/knock'

# Pagination
gem 'api-pagination'
gem 'pagy'

group :development, :test do
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'simplecov', require: false
end

group :development do
  gem 'annotate', require: false
  gem 'listen'
end

group :test do
  # TODO(khataev): remove
  gem 'addressable'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'webmock'
end
