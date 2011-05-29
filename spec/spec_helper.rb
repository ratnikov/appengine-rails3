require 'rspec'

require 'rack/test'

require 'thrust'

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
