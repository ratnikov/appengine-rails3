Feature: In order to foster community, people should be able to leave comments.

  Scenario: Non-logged in visitor should see comments, but no form
    Given user "joe@example.com" creates a "My first comment" comment
      And I am on the home page

     Then I should see "My first comment"
      And I should see "joe wrote"
      And I should not see "example.com"

      And I should not see "Leave a comment"

  Scenario: Should support legacy comments lacking timestamps
    Given someone left "anonymous comment" comment without timestamps

     When I am on the home page

     Then I should see "anonymous comment"

  @wip
  Scenario: An admin should be able to delete comments
    Given user "joe@example.com" creates a "Your mother was a hamster!" comment
      And I am logged in as "joe@example.com" admin

     When I press "Delete" within "Your mother was a hamster!" comment

     Then I should not see "Your mother was a hamster!"
      And comment "Your mother was a hamser!" should not exist


  Scenario: User leaving comments
    Given I am logged in as "joe@example.com"
      And I am on the home page

     Then I should see "Leave a comment"

     When I fill in "comment[text]" with "Hello world!"
      And I press "Post comment"

     Then comment "Hello world!" should exist
