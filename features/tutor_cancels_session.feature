Feature: Tutor cancels a tutoring session
  As a signed-in tutor
  I want to cancel an upcoming tutoring session
  So that I can free up my time

  Background:
    Given I am a signed-in tutor
    And the subject "Math" exists
    And the subject "Biology" exists


  @cancel_happy 
  Scenario: Successfully cancels an upcoming session from the list 
    And the following session exists:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-15T10:00:00Z | 2026-10-15T10:59:00Z | 1        | Biology | scheduled |
    And I am on the home page
    When I click on "View My Sessions (Tutor)"
    And I click "Cancel" for the upcoming sessions starting at "2026-10-15T10:00:00Z"
    Then I should see the cancel confirmation page
    And I should see "Biology"
    And I should see "Capacity: 1"
    And I should see "2026-10-15T10:00:00Z"
    When I confirm the cancellation
    Then I should be on the tutor upcoming sessions page
    And I should see "Session cancelled"
    And I should see "Status: cancelled"
    And the session should have status "cancelled"



  @cancel_no 
  Scenario: Choose not to cancel an upcoming session
    And the following session exists:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-17T10:00:00Z | 2026-10-17T10:59:00Z | 2        | Biology | scheduled |
    And I am on the home page
    When I click on "View My Sessions (Tutor)"
    And I click "Cancel" for the upcoming sessions starting at "2026-10-17T10:00:00Z"
    Then I should see the cancel confirmation page
    When I choose not to cancel the session
    Then I should be on the tutor upcoming sessions page
    And I should see "Biology"
    And I should see "Capacity: 2"
    And I should see "2026-10-17T10:00:00Z"


  @cancel_unauthorized
  Scenario: Tutor cannot cancel someone else's session
    And the following session exists for another tutor:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-16T10:00:00Z | 2026-10-16T10:59:00Z | 1        | Math    | scheduled |
    When I attempt to cancel that other tutor's booking directly
    Then I should be on the tutor upcoming sessions page
    And I should see "You are not authorized to cancel the session"


  @cancel_past
  Scenario: Tutor cannot cancel a past session
    And the following session exists:
      | start_at             | end_at               | capacity | subject | status    |
      | 2026-10-11T10:00:00Z | 2026-10-11T10:59:00Z | 2        | Math    | completed |
    When I attempt to cancel that past session directly
    Then I should be on the tutor upcoming sessions page
    And I should see "You can only cancel upcoming sessions"
