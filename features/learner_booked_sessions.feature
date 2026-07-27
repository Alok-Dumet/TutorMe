Feature: Learner views upcoming and past booked sessions
  As a signed-in learner
  I want to view my upcoming and past tutoring sessions
  So that I can manage my schedule and review my learning

  @upcoming
  Scenario: View upcoming booked sessions from the home page
    Given I am a signed-in learner
    And the learner has the following bookings:
      | subject | tutor_name    | start_at              | end_at                | status    | attended |
      | Math    | Emily Johnson | 2030-01-10T10:00:00Z  | 2030-01-10T11:00:00Z  | scheduled |          |
      | Biology | Sarah Miller  | 2020-01-10T10:00:00Z  | 2020-01-10T11:00:00Z  | completed | true     |
    And I am on the home page
    When I click on "View My Sessions"
    Then I should be on the learner upcoming sessions page
    And I should see "My Upcoming Sessions"
    And I should see "Math"
    And I should see "Emily Johnson"
    And I should see "scheduled"
    And I should not see "Biology"
    And I should see "View past sessions"

  @past
  Scenario: View past booked sessions and attendance information
    Given I am a signed-in learner
    And the learner has the following bookings:
      | subject   | tutor_name    | start_at              | end_at                | status    | attended |
      | Math      | Emily Johnson | 2020-01-10T10:00:00Z  | 2020-01-10T11:00:00Z  | completed | true     |
      | Biology   | Sarah Miller  | 2020-02-10T10:00:00Z  | 2020-02-10T11:00:00Z  | completed | false    |
      | Chemistry | Michael Chen  | 2020-03-10T10:00:00Z  | 2020-03-10T11:00:00Z  | completed |          |
    And I am on the home page
    When I click on "View My Sessions"
    And I click on "View past sessions"
    Then I should be on the learner past sessions page
    And I should see "My Past Sessions"
    And I should see "Math"
    And I should see "Biology"
    And I should see "Chemistry"
    And I should see "Present"
    And I should see "Absent"
    And I should see "Not recorded"
    And I should see "Back to upcoming sessions"

  @no_upcoming
  Scenario: Learner has no upcoming sessions
    Given I am a signed-in learner
    And the learner has the following bookings:
      | subject | tutor_name    | start_at              | end_at                | status    | attended |
      | Math    | Emily Johnson | 2020-01-10T10:00:00Z  | 2020-01-10T11:00:00Z  | completed | true     |
    And I am on the home page
    When I click on "View My Sessions"
    Then I should see "You have no upcoming sessions."
    And I should see "View past sessions"

  @no_past
  Scenario: Learner has no past sessions
    Given I am a signed-in learner
    And the learner has the following bookings:
      | subject | tutor_name    | start_at              | end_at                | status    | attended |
      | Math    | Emily Johnson | 2030-01-10T10:00:00Z  | 2030-01-10T11:00:00Z  | scheduled |          |
    And I am on the home page
    When I click on "View My Sessions"
    And I click on "View past sessions"
    Then I should see "You have no past sessions."
    And I should see "Back to upcoming sessions"

  @auth
  Scenario: Unauthenticated user cannot access learner sessions pages
    Given I am on the home page
    When I visit the "My Sessions" page directly
    Then I should be redirected to the login page