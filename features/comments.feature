Feature: In order to foster community, people should be able to leave comments.

  Scenario: Non-logged in visitor should see comments, but no form
    Given user "joe@example.com" creates a "My first comment" comment
    Given I am on the home page

     Then I should see "My first comment"
     Then I should not see "Leave a comment"

  Scenario: User leaving comments
    Given I am logged in as "joe@example.com"
      And I am on the home page

     Then I should see "Leave a comment"

     When I fill in "comment[text]" with "Hello world!"
      And I press "Post comment"

     Then comment "Hello world!" should exist
