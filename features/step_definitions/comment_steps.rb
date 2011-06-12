Then /^comment "(.*)" should exist$/ do |text|
  Comment.exists?(:text => text).should be_true
end
