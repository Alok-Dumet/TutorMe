Feature: Admin adds a new subject
  As an admin
  I want to create a subject with name and unique code
  So that tutors can tag sessions with it

  @happy
  Scenario: Successfully create a subject
    Given I am a signed-in admin
    When I visit the "New Subject" page
    And I fill "Name" with "Calculus"
    And I fill "Code" with "MATH101"
    And I click "Create Subject"
    Then I should see "Subject created"
    And I should see "Calculus"
    And I should see "MATH101"

  @sad_missing_code
  Scenario: Fail to create subject when code is missing
    Given I am a signed-in admin
    When I visit the "New Subject" page
    And I fill "Name" with "Physics"
    And I leave "Code" blank
    And I click "Create Subject"
    Then I should see "Code can't be blank"

  @sad_duplicate_code
  Scenario: Fail to create subject when code is duplicate
    Given I am a signed-in admin
    And a subject already exists with name "Calculus" and code "MATH101"
    When I visit the "New Subject" page
    And I fill "Name" with "Linear Algebra"
    And I fill "Code" with "MATH101"
    And I click "Create Subject"
    Then I should see "Code has already been taken"
