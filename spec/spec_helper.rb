require 'rspec'


require 'thrust'

require 'capybara/rspec'

RSpec.configure do |config|
  # enable thrust environment except for :thrust => false examples
  config.around(:thrust => proc { |val| val }) { |example| Thrust::Development.engaged { example.run } }
end
