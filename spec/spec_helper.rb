ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'thrust'

require 'capybara/rspec'

RSpec.configure do |config|
  # enable thrust environment except for :thrust => false examples
  config.around(:thrust => proc { |val| val }) { |example| Thrust::Development.engaged { example.run } }
end
