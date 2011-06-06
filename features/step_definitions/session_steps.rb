Given /^I am logged in as "(.*)"$/ do |email|
  visit '/'

  click_link 'login'

  fill_in 'email', :with => email
  click_button 'Log in!'
end
