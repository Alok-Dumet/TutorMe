Feature: Tutor views feedback received from learners
    As a Tutor
    I want to view all ratings and comments I have received from learners
    so that I can evaluate my teaching performance and improve future sessions

    Background:
        Given I am a logged-in tutor
        And the following learners exist:
        | email               | password    | first_name | last_name |
        | janedoe@example.com | password123 | Jane       | Doe       |
        | johndoe@example.com | password456 | John       | Doe       |
        And the following subjects exist:
        | name      | code    |
        | Calculus  | MATH101 |
        | Chemistry | CHEM201 |
        And the following sessions exist:
        | subject   | start_at             | end_at               | status     |
        | Calculus  | 2025-09-10T10:00:00Z | 2025-09-10T11:00:00Z | completed  |
        | Chemistry | 2025-09-12T14:00:00Z | 2025-09-12T15:00:00Z | completed  |
        And the following feedback exists:
        | session   | learner_email        | score | comment                     |
        | Calculus  | janedoe@example.com  | 5     | Very clear explanations!    |
        | Chemistry | johndoe@example.com  | 4     | Helpful but a bit too fast. |
        And I am on the Tutor Feedback page

    Scenario: View all feedback received
        When I view my feedback list
        Then I should see text "Very clear explanations!"
        And I should see text "Helpful but a bit too fast."
        And I should see text "Average Rating: 4.5"
        And I should see text "Total Reviews: 2"

    Scenario: View feedback filtered by subject
        When I filter feedback by subject "Calculus"
        Then I should see only 1 feedback items displayed
        And I should see text "Very clear explanations!"

    Scenario: View feedback with no results
        Given I am a tutor with no feedback yet
        When I visit the Tutor Feedback page
        Then I should see text "No feedback yet"

    Scenario: Prevent viewing another tutor’s feedback
        Given another tutor exists
        When I try to access that tutor’s feedback page
        Then I should see text "Access denied"

    Scenario: View feedback pagination
        Given I have more than 10 feedback entries
        When I visit the Tutor Feedback page
        Then I should see only 10 feedback items displayed
        And I should see pagination controls
