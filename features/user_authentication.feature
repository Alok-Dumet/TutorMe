Feature: User Authentication / Identity
  As a learner
  I want to create an account, log in, and log out
  So that I can access the app in the correct role

  Background:
    Given I am on the home page

  Scenario: User signs up with valid details
    Given I am on the sign-up page
    When I fill in "First name" with "Example"
    And I fill in "Last name" with "Student"
    And I fill in "Email" with "example@gmail.com"
    And I fill in "Password" with "password"
    And I fill in "Confirm Password" with "password"
    And I press "Sign up"
    Then I should see a message "Account Created!"
    And I should be redirected to login page

  Scenario: User cannot sign up with a missing email
    Given I am on the sign-up page
    When I fill in "First name" with "Example"
    And I fill in "Last name" with "Student"
    And I fill in "Email" with ""
    And I fill in "Password" with "password"
    And I fill in "Confirm Password" with "password"
    And I press "Sign up"
    Then I should see an error message "Email can't be blank"

  Scenario: User cannot sign up with a missing password
    Given I am on the sign-up page
    When I fill in "First name" with "Example"
    And I fill in "Last name" with "Student"
    And I fill in "Email" with "example@gmail.com"
    And I fill in "Password" with ""
    And I fill in "Confirm Password" with ""
    And I press "Sign up"
    Then I should see an error message "Password can't be blank"

  Scenario: User cannot sign up with an email that is already taken
    Given an account exists for "example@gmail.com" with password "password"
    And I am on the sign-up page
    When I fill in "First name" with "Example"
    And I fill in "Last name" with "Student"
    And I fill in "Email" with "example@gmail.com"
    And I fill in "Password" with "password"
    And I fill in "Confirm Password" with "password"
    And I press "Sign up"
    Then I should see an error message "Email has already been taken"

  Scenario: User logs in with valid credentials
    Given I am on the login page
    And an account exists for "example@gmail.com" with password "password"
    When I fill in "Email" with "example@gmail.com"
    And I fill in "Password" with "password"
    And I press "Log in"
    Then I should be redirected to the home page

  Scenario: User logs in with invalid credentials
    Given I am on the login page
    And an account exists for "example@gmail.com" with password "password"
    When I fill in "Email" with "example@gmail.com"
    And I fill in "Password" with "incorrectpassword"
    And I press "Log in"
    Then I should see an error message "Invalid email or password"

  Scenario: Logged-in user logs out
    Given I am logged in as "example@gmail.com"
    When I press "Log out"
    Then I should be redirected to the login page