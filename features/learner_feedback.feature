Feature: Learner submits feedback
  As a signed-in learner
  I want to submit feedback about my tutoring session
  So that I can share my experience with my tutor to help others

  Background:
    Given I am a signed-in learner
    And I have a completed session with "Michael Chen" where I was marked present

  @happy_submits_feedback
  Scenario: Submit valid feedback
    When I navigate to the feedback form for "Michael Chen"
    And I select a rating of "5"
    And I fill in "Comment" with "Great tutor!"
    And I press "Submit Feedback"
    Then I should see "Thank you for your feedback!"

  @sad_missing_rating
  Scenario: Submit invalid feedback (missing rating)
    When I navigate to the feedback form for "Michael Chen"
    And I fill in "Comment" with "Pretty good"
    And I press "Submit Feedback"
    Then I should see "Rating can't be blank"

  @happy_present_can_leave_feedback
  Scenario: Learner marked present can leave feedback
    When I navigate to the feedback form for "Michael Chen"
    Then I should see "Submit Feedback"

  @sad_absent_cannot_leave_feedback
  Scenario: Learner not marked present cannot leave feedback
    Given I have a completed session with "Michael Chen" where I was marked absent
    When I visit the session page for "Michael Chen"
    Then I should not see "Leave Feedback"
    And I should see "You were not marked present for this session"
