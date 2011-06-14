ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'thrust'

require 'capybara/rspec'

DatabaseCleaner[:datastore].strategy = :truncation

RSpec.configure do |config|
  # enable thrust environment except for :thrust => false examples
  config.around do |example| 
    unless example.metadata[:engage_thrust] == false
      Thrust::Development.engaged { example.run }
    else
      example.run
    end
  end

  config.after { DatabaseCleaner.clean }
end
