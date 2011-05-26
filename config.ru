# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

require 'thrust/login_middleware'

run Thrust::LoginMiddleware.new
# run AppengineRails3::Application
