Feature: Admin approves or rejects tutor applications
    As an admin
    I want to approve or reject a submitted tutor application
    So that I can manage the active list of tutors

    Background:
        Given I am a signed-in admin
        And I am on the home page
        And the following learners exist:
            | email                 | password    | first_name | last_name |
            | janedoe@example.com   | password123 | Jane       | Doe       |
            | johnsmith@example.com | password123 | John       | Smith     |


    @button
    Scenario: See the manage applications link
        Then I should see the "Manage Applications" link

    @visit
    Scenario: Visit the manage applications page
        Given the following tutor applications exist:
            | learner    | reason                                                |
            | Jane Doe   | I have 3 years prior experience of tutoring Calculus. |
            | John Smith | I really enjoy tutoring!                              |
        When I click the "Manage Applications" link
        Then I should see the manage applications page
        And I should see a tutor application for "Jane Doe"
        And I should see a tutor application for "John Smith"
     
    @happy_approve
    Scenario: Approve a tutor application
        Given the following tutor applications exist:
            | learner    | reason                                                |
            | Jane Doe   | I have 3 years prior experience of tutoring Calculus. |
            | John Smith | I really enjoy tutoring!                              |
        And I visit the manage applications page
        When I press the "Approve" button for "Jane Doe"
        Then the application status for "Jane Doe" should be "approved"
        And "Jane Doe" should be a tutor
        And I should see "Application approved"

    @happy_reject
    Scenario: Reject a tutor application
        Given the following tutor applications exist:
            | learner    | reason                                                |
            | Jane Doe   | I have 3 years prior experience of tutoring Calculus. |
            | John Smith | I really enjoy tutoring!                              |
        And I visit the manage applications page
        When I press the "Reject" button for "Jane Doe"
        Then the application for "Jane Doe" should be deleted
        And "Jane Doe" should not be a tutor
        And I should see "Application rejected"
        And I should not see a tutor application for "Jane Doe"

    @no_applications
    Scenario: No pending applications
        Given there are no pending applications in the database
        And I visit the manage applications page
        Then I should see "There are no pending applications to review"
        Then I should not see any tutor applications
