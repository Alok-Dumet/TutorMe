Feature: Tutor marks a learner's attendance for a tutoring session
    As a Tutor
    I want to mark a learner's attendance for a tutoring session
    so that the learner and I can both keep track of their session attendance
    
    Background:
        Given I am a signed-in tutor
        And the following learners exist:
        | email               | password    | first_name | last_name |
        | janedoe@example.com | password123 | Jane       | Doe       |
        And the subject "Calculus" exists
        And the following session exists:
        | subject  | start_at             | end_at               | capacity | status    |
        | Calculus | 2025-10-24T12:00:00Z | 2025-10-24T12:59:59Z | 1        | Scheduled |
        And I am on the "Session Details" page for the session at "2025-10-24T12:00:00Z"

    Scenario: Mark a learner as present
        When I mark the learner as "Present"
        And I save the attendance
        Then I should see a message "Learner marked as present"
        And the learner's attendance for the session should be set to "true"

    Scenario: Mark a learner as absent
        When I mark the learner as "Absent"
        And I save the attendance
        Then I should see a message "Learner marked as absent"
        And the learner's attendance for the session should be set to "false"

    Scenario: Update a previously marked attendance
        Given the learner is marked as "Present"
        When I mark the learner as "Absent"
        And I save the attendance
        Then I should see a message "Learner marked as absent"
        And the learner's attendance for the session should be set to "false"

    Scenario: Disable saving attendance when neither attendance option is selected
        Given the learner's attendance is not marked
        When I save the attendance
        Then I should see a message "No attendance option selected."

    Scenario: Disable attendance functionality for sessions that have not yet occurred
        Given the session has not yet occurred
        Then I should not see the "Present" option
        And I should not see the "Absent" option
        And I should not see the "Save" button