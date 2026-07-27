Feature: Tutor Application
  As a learner
  So that I can access tutor privileges like reserving a room and booking sessions
  I want to apply to become a tutor

  @link
  Scenario: Learner goes to the Home page
    Given I am a signed-in learner
    When I visit the Home page
    Then I should see the "Apply to be a Tutor" link

  @apply
  Scenario: Learner goes to the application page
    Given I am a signed-in learner
    When I visit the Home page
    And I click the "Apply to be a Tutor" link
    Then I should see the tutor application page

  @submit
  Scenario: Learner submits an application
    Given I am a signed-in learner
    And I visit the tutor application page
    And I enter reason "I want to teach"
    When I click the "Submit Application" button
    Then I should see a message that my application was submitted

  @already_tutor  
  Scenario: Learner who is already a tutor
    Given I am a signed-in learner
    And I am a Tutor
    When I visit the Home page
    Then I should not see the "Apply to be a Tutor" link
    And I should not see the "Pending review" message

  @pending
  Scenario: Learner with a pending application
    Given I am a signed-in learner
    And I have a pending application
    When I visit the Home page
    Then I should not see the "Apply to be a Tutor" link
    And I should see "Pending"

  @approved  
  Scenario: Admin approves a learner’s application
    Given an admin has approved my application
    When I sign-in as a learner
    Then I should see the "Create Session" link