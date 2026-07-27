Feature: Show remaining seats for tutoring sessions
  As a signed-in learner
  I want to see how many seats are left in each session
  So that I can choose sessions that are not already full

  Background:
    Given I am a signed-in learner

  @seats_remaining
  Scenario: Seats remaining shown in search results and on session details
    And the subject "Linear Algebra" exists
    And the following tutors and sessions exist:
      | tutor_name  | subject        | session_start          | session_end            | capacity |
      | Alice Wong  | Linear Algebra | 2035-01-10T10:00:00Z   | 2035-01-10T11:00:00Z   | 3        |
    And I am on the "Find a Session" page
    When I choose subject "Linear Algebra"
    And I enter start "2035-01-10T09:00:00Z" and end "2035-01-10T12:00:00Z"
    And I run the search
    Then I should see "Seats remaining:" in the search results
    And I should see "3 / 3" in the search results

    When I select the session for tutor "Alice Wong" from "2035-01-10T10:00:00Z" to "2035-01-10T11:00:00Z"
    And I confirm the booking
    When I visit the session details page again for tutor "Alice Wong" from "2035-01-10T10:00:00Z" to "2035-01-10T11:00:00Z"
    Then I should see "Seats remaining:" on the session details page
    And I should see "2 of 3 seats available" on the session details page


  @seats_full
  Scenario: Session that is full is marked as Full and cannot be booked
    And the subject "Linear Algebra" exists
    And the following tutors and sessions exist:
      | tutor_name  | subject        | session_start          | session_end            | capacity |
      | Alice Wong  | Linear Algebra | 2035-01-10T10:00:00Z   | 2035-01-10T11:00:00Z   | 1        |
    And the following learners are booked into sessions:
      | learner_email        | tutor_name  | subject        | session_start          | session_end            |
      | booked@example.com   | Alice Wong  | Linear Algebra | 2035-01-10T10:00:00Z   | 2035-01-10T11:00:00Z   |
    And I am a signed-in learner with email "newlearner@example.com"
    And I am on the "Find a Session" page
    When I choose subject "Linear Algebra"
    And I enter start "2035-01-10T09:00:00Z" and end "2035-01-10T12:00:00Z"
    And I run the search
    Then I should see "Seats remaining:" in the search results
    And I should see "Full" in the search results

  @seats_cancel
  Scenario: Cancelling a booking increases seats remaining
    And the subject "Linear Algebra" exists
    And the following tutors and sessions exist:
      | tutor_name  | subject        | session_start          | session_end            | capacity |
      | Alice Wong  | Linear Algebra | 2035-01-10T10:00:00Z   | 2035-01-10T11:00:00Z   | 2        |
    And I am a signed-in learner
    And I am on the "Find a Session" page
    When I choose subject "Linear Algebra"
    And I enter start "2035-01-10T09:00:00Z" and end "2035-01-10T12:00:00Z"
    And I run the search
    And I select the session for tutor "Alice Wong" from "2035-01-10T10:00:00Z" to "2035-01-10T11:00:00Z"
    And I confirm the booking
    When I visit the session details page again for tutor "Alice Wong" from "2035-01-10T10:00:00Z" to "2035-01-10T11:00:00Z"
    Then I should see "Seats remaining:" on the session details page
    And I should see "1 of 2 seats available" on the session details page

    When I go to my learner sessions page
    And I choose to cancel that booking
    And I confirm the cancellation
    And I visit the session details page again for tutor "Alice Wong" from "2035-01-10T10:00:00Z" to "2035-01-10T11:00:00Z"
    Then I should see "Seats remaining:" on the session details page
    And I should see "2 of 2 seats available" on the session details page