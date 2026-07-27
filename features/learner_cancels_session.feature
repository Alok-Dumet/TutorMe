Feature: Learner cancels an upcoming booked session
  As a signed-in learner
  I want to cancel an upcoming tutoring session
  So that I can free up my time and allow others to book that slot

  Background:
    Given I am a signed-in learner

  @cancel_happy
  Scenario: Successfully cancel an upcoming session from the list
    And the learner has the following bookings:
      | subject | tutor_name    | start_at              | end_at                | status    | attended |
      | Math    | Emily Johnson | 2030-01-10T10:00:00Z  | 2030-01-10T11:00:00Z  | scheduled |          |
    And I am on the home page
    When I click on "View My Sessions"
    And I click "Cancel" for the upcoming session starting at "2030-01-10T10:00:00Z"
    Then I should see the cancel confirmation page
    And I should see "Are you sure you want to cancel this session?"
    And I should see "Math"
    And I should see "Emily Johnson"
    When I choose to confirm the cancellation
    Then I should be on the learner upcoming sessions page
    And I should see "Session cancelled"
    And I should see "You have no upcoming sessions."

  @cancel_no
  Scenario: Choose not to cancel an upcoming session
    And the learner has the following bookings:
      | subject | tutor_name    | start_at              | end_at                | status    | attended |
      | Math    | Emily Johnson | 2030-01-10T10:00:00Z  | 2030-01-10T11:00:00Z  | scheduled |          |
    And I am on the home page
    When I click on "View My Sessions"
    And I click "Cancel" for the upcoming session starting at "2030-01-10T10:00:00Z"
    And I choose not to cancel the session
    Then I should be on the learner upcoming sessions page
    And I should see "Math"
    And I should see "Emily Johnson"
    And I should not see "Session cancelled"

  @cancel_unauthorized
  Scenario: Learner cannot cancel someone else’s booking
    And the learner has the following bookings:
      | subject | tutor_name    | start_at              | end_at                | status    | attended |
      | Math    | Emily Johnson | 2030-01-10T10:00:00Z  | 2030-01-10T11:00:00Z  | scheduled |          |
    And another learner has a booking for:
      | subject | tutor_name   | start_at              | end_at                | status    |
      | Biology | Sarah Miller | 2030-01-11T10:00:00Z  | 2030-01-11T11:00:00Z  | scheduled |
    When I attempt to cancel that other learner's booking directly
    Then I should be on the learner upcoming sessions page
    And I should see "You are not authorized to cancel that session"

  @cancel_past_direct
  Scenario: Learner cannot cancel a past session via direct URL
    And the learner has the following bookings:
      | subject | tutor_name    | start_at              | end_at                | status    | attended |
      | Math    | Emily Johnson | 2020-01-10T10:00:00Z  | 2020-01-10T11:00:00Z  | completed | true     |
    When I attempt to cancel that past booking directly
    Then I should be on the learner upcoming sessions page
    And I should see "You can only cancel upcoming sessions"