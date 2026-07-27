Feature: Tutor updates session link
    As a Tutor
    I want to update the meeting link for my tutor sessions
    so that I can fix mistakes on my session

  Background:
    Given I am a signed-in tutor
    And the subject "Math" exists
    And the subject "Biology" exists

  @edit_happy
  Scenario: View upcoming booked sessions from the home page
    Given I am a signed-in tutor
    And the following session exists:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-15T10:00:00Z | 2026-10-15T10:59:00Z | 1        | Biology | scheduled |
      | 2026-10-11T10:00:00Z | 2026-10-11T10:59:00Z | 2        | Math    | completed |
    And I am on the home page
    When I click on "View My Sessions (Tutor)"
    Then I should be on the tutor upcoming sessions page
    And I should see "My Upcoming Sessions"
    And I click Edit for the upcoming session starting at "2026-10-15T10:00:00Z"
    Then I should see the edit session page
    And I should see "Biology"
    And I should see "Capacity: 1"
    And I should see "2026-10-15T10:00:00Z"
    When I enter the meeting link "https://zoom.example.us"
    And I make the update
    Then I should be on the tutor upcoming sessions page
    And I should see a link with text "Join Session" pointing to "https://zoom.example.us"

  @edit_no
  Scenario: View upcoming booked sessions from the home page
    Given I am a signed-in tutor
    And the following session exists:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-15T10:00:00Z | 2026-10-15T10:59:00Z | 1        | Biology | scheduled |
      | 2026-10-11T10:00:00Z | 2026-10-11T10:59:00Z | 2        | Math    | completed |
    And I am on the home page
    When I click on "View My Sessions (Tutor)"
    Then I should be on the tutor upcoming sessions page
    And I should see "My Upcoming Sessions"
    And I click Edit for the upcoming session starting at "2026-10-15T10:00:00Z"
    Then I should see the edit session page
    And I should see "Biology"
    And I should see "Capacity: 1"
    And I should see "2026-10-15T10:00:00Z"
    When I enter the meeting link "https://zoom.example.us"
    And I cancel the update
    Then I should be on the tutor upcoming sessions page
    And I should see a link with text "Join Session" pointing to "https://zoom.us/test-session"

  @edit_unauthorized
  Scenario: Tutor cannot edit someone else's session
    Given I am a signed-in tutor
    And the following session exists for another tutor:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-16T10:00:00Z | 2026-10-16T10:59:00Z | 1        | Math    | scheduled |
    When I attempt to edit that other tutor's booking directly
    Then I should be on the tutor upcoming sessions page
    And I should see "You cannot edit another tutor's session"

  @edit_past
  Scenario: Tutor cannot edit past sessions
    And the following session exists:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-11T10:00:00Z | 2026-10-11T10:59:00Z | 2        | Math    | completed |
    When I attempt to edit that past session directly
    Then I should be on the tutor upcoming sessions page
    And I should see "You can only edit upcoming sessions"