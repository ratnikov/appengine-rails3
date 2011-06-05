require 'rspec'


require 'thrust'

require 'capybara/rspec'

RSpec.configure do |config|
  config.around { |example| Thrust::Development.engaged { example.run } }
end
