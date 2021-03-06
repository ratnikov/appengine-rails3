Feature: In order to foster community, people should be able to leave comments.

  Scenario: Non-logged in visitor should see comments, but no form
    Given user "joe@example.com" creates a "My first comment" comment
      And I am on the home page

     Then I should see "My first comment"
      And I should see "joe wrote"
      And I should not see "example.com"

      And I should not see "Leave a comment"
      And I should not see "Delete" button

  Scenario: Should support legacy comments lacking timestamps
    Given someone left "anonymous comment" comment without timestamps

     When I am on the home page

     Then I should see "anonymous comment"

  Scenario: An admin should be able to delete comments
    Given user "joe@example.com" creates a "Your mother was a hamster!" comment
      And I am logged in as "joe@example.com" admin

     When I press "Delete" within "//div[@class='comment'][contains(string(), 'Your mother was a hamster!')]"

     Then I should not see "Youre mother was a hamster!"
      And comment "Your mother was a hamster!" should not exist


  Scenario: User leaving comments
    Given I am logged in as "joe@example.com"
      And I am on the home page

     Then I should see "Leave a comment"

     When I fill in "comment[text]" with "Hello world!"
      And I press "Post comment"

     Then comment "Hello world!" should exist

  Scenario: User trying to leave blank comments
    Given I am logged in as "joe@example.com"
      And I am on the home page

     When I press "Post comment"

     Then I should see "Text can't be blank"

     When I fill in "comment[text]" with "Updated text"
      And I press "Post comment"

     Then comment "Updated text" should exist
