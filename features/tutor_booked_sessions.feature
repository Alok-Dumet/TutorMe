Feature: Tutor views upcoming and past booked sessions
  As a signed-in tutor
  I want to view my upcoming and past tutoring sessions
  So that I can manage my schedule and view sessions

  Background:
    Given I am a signed-in tutor
    And the subject "Math" exists
    And the subject "Biology" exists
    

  @upcoming
  Scenario: View upcoming booked sessions from the home page
    Given I am a signed-in tutor
    And the following session exists:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-15T10:00:00Z | 2026-10-15T10:59:00Z | 1        | Biology | scheduled |
      | 2026-10-11T10:00:00Z | 2026-10-11T10:59:00Z | 2        | Math    | completed |
    And I am on the home page
    When I click on "View My Sessions (Tutor)"
    Then I should be on the tutor upcoming sessions page
    And I should see "My Upcoming Sessions (Tutor)"
    And I should see "Biology"
    And I should see "Capacity: 1"
    And I should see "2026-10-15T10:00:00Z"
    And I should not see "Math"
    And I should not see "Capacity: 2"
    And I should see "View past sessions"

  @past
  Scenario: View past booked sessions and attendance information
    Given I am a signed-in tutor
    And the following session exists:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-15T10:00:00Z | 2026-10-15T10:59:00Z | 1        | Biology | scheduled |
      | 2026-10-11T10:00:00Z | 2026-10-11T10:59:00Z | 2        | Math    | completed |
    And I am on the home page
    When I click on "View My Sessions (Tutor)"
    Then I should be on the tutor upcoming sessions page
    And I should see "My Upcoming Sessions (Tutor)"
    When I click on "View past sessions"
    Then I should be on the tutor past sessions page
    And I should see "My Past Sessions (Tutor)"
    And I should not see "Biology"
    And I should not see "Capacity: 1"
    And I should see "Math"
    And I should see "Capacity: 2"
    And I should see "2026-10-11T10:00:00Z"
    And I should see "Back to upcoming sessions"

  @no_upcoming
  Scenario: Tutor has no upcoming sessions
    Given I am a signed-in tutor
    And the following session exists:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-11T10:00:00Z | 2026-10-11T10:59:00Z | 2        | Math    | completed |
    And I am on the home page
    When I click on "View My Sessions (Tutor)"
    Then I should see "You have no upcoming sessions."
    And I should see "View past sessions"

  @no_past
  Scenario: Tutor has no past sessions
    Given I am a signed-in tutor
    And the following session exists:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-15T10:00:00Z | 2026-10-15T10:59:00Z | 1        | Biology | scheduled |
    And I am on the home page
    When I click on "View My Sessions (Tutor)"
    And I click on "View past sessions"
    Then I should see "You have no past sessions."
    And I should see "Back to upcoming sessions"

  @auth
  Scenario: Unauthenticated user cannot access tutor sessions pages
    Given I am on the home page
    And I am logged out
    When I visit the tutor sessions page directly
    Then I should be redirected to the login page