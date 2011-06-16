Given /^I am logged in as "(.*)"( admin)?$/ do |email, admin|
  visit "/"

  # make sure we're logged out
  click_link 'logout' rescue nil

  click_link 'login'

  fill_in 'email', :with => email
  check 'admin' unless admin.blank?

  click_button 'Log in!'
end

Given /^I log out$/ do
  visit '/'

  click_link 'logout'
end
