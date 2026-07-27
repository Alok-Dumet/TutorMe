Feature: Tutor posts a new session
  As a signed in and verified tutor,
  I want to post a session,
  So that I can allow others to sign up

  Background:
    Given I am a signed-in tutor
    And the subject "Math" exists
    And the following session exists:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-15T10:30:00Z | 2026-10-15T11:29:00Z | 1        | Math    | Scheduled |

  @happy
  Scenario: Tutor posts an session with valid information
    And I am on new session page,
    When I fill in the session start time with "2026-10-15T12:00"
    And I set the duration to 1 hour and 0 minutes
    And I fill in "Capacity" with "1"
    And I fill in "Meeting Link" with "https://zoom.us/my-session"
    And I select "Math" from the Subject dropdown
    And I press "Create new session"
    Then I should be on the tutor upcoming sessions page
    And I should see the message "Session successfully created"
    And I should see a link with text "Join Session" pointing to "https://zoom.us/my-session"

  @unknown
  Scenario: Tutor creates a post with missing/unknown information
    And I am on new session page,
    When I fill in the session start time with "2026-10-15T10:00"
    # User forgets to select duration or leaves other fields blank implied
    And I select "Math" from the Subject dropdown
    And I press "Create new session"
    Then I should see an error message saying it is missing information

  @overlap
  Scenario: Tutor creates a post overlapping with existing session
    And I am on new session page,
    When I fill in the session start time with "2026-10-15T10:00"
    And I set the duration to 1 hour and 0 minutes
    And I fill in "Capacity" with "1"
    And I select "Math" from the Subject dropdown
    And I press "Create new session"
    And this session overlaps with existing session
    Then I should see an error message that there is a time conflict