ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'thrust'

require 'capybara/rspec'

RSpec.configure do |config|
  # enable thrust environment except for :thrust => false examples
  config.around do |example| 
    Thrust::Development.engaged { example.run } unless example.metadata[:thrust] == false
  end
end
