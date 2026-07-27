Feature: Admin archives subjects
  As an admin
  So that I can remove subjects from use without losing history
  I want to archive subjects that should no longer be used

  Background:
    Given the following subjects exist:
      | name        | code | description         |
      | Mathematics | MTH  | Basic math topics   |
      | Physics     | PHY  | Intro to physics    |

  Scenario: Admin successfully archives a subject
    Given I am logged in as an admin
    When I go to the subjects management page
    And I click "Delete" for the subject "Physics"
    Then I should see "Subject was successfully archived."
    And I should not see "Physics" on the subjects page

  Scenario: Archived subjects are not available for new sessions
    Given I am a signed-in tutor
    And the subject "Physics" has been archived
    When I go to create a new tutor session
    Then I should not see "Physics" in the subject dropdown

  Scenario: Non-admin user cannot access subjects management
    Given I am logged in as a learner
    When I go to the subjects management page
    Then I should be redirected to the login page
    And I should see "Please log in as admin"

  Scenario: Archived subject still appears on an existing session
    Given I am logged in as a learner
    And a tutor session exists with subject "Mathematics"
    And the subject "Mathematics" has been archived
    When I visit the details page for that tutor session
    Then I should see "Mathematics" as the subject for the session
