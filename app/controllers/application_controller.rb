class ApplicationController < ActionController::Base
  include Thrust::ControllerExtensions
  protect_from_forgery
end
