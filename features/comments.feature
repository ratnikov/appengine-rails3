Feature: In order to foster community, people should be able to leave comments.

  @wip
  Scenario: User leaving comments
    Given I am logged in as "joe@example.com"
      And I am on the home page

     When I fill in "comment[text]" with "Hello world!"
      And I press "Post comment"

     Then comment "Hello world!" should exist
