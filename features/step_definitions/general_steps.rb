Then /^I should not see "(.*)" button$/ do |text|
  page.should have_no_selector("//input[@type='submit'][@value='#{text}']")
end
