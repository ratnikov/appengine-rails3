Given /^user "(.*)" creates a "(.*)" comment$/ do |email, text|
  When %{I am logged in as "#{email}"}

  And %{I am on the home page}

  And %{I fill in "comment[text]" with "#{text}"}
  And %{I press "Post comment"}

  And %{I log out}

  Then %{comment "#{text}" should exist}
end

Then /^comment "(.*)" should exist$/ do |text|
  Comment.exists?(:text => text).should be_true
end
