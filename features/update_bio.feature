Feature: Tutor updates their bio
    As a Tutor
    I want to update my bio
    So that I can keep my information up-to-date for learners

    Background:
        Given I am a signed-in tutor
        And my bio is "Hi, I am a tutor!"
        And I am on the home page

    @happy
    Scenario: Update bio with new information
        When I click on "Update my Profile"
        And I change the bio to "Hi! This is my new bio!"
        And I click the "Update" button
        Then I should see "Changes saved"
        When I visit my tutor profile page
        Then I should see "Hi! This is my new bio!"

    @unchanged
    Scenario: Update bio with no changes
        When I click on "Update my Profile"
        And I click the "Update" button
        Then I should see "No changes made"

    @empty
    Scenario: Update to empty bio
        When I click on "Update my Profile"
        And I change the bio to ""
        And I click the "Update" button
        Then I should see "Changes saved"
        And I visit my tutor profile page
        Then I should see "No bio has been provided."

    @char_limit
    Scenario: Bio exceeds character limit
        When I click on "Update my Profile"
        And I change the bio to a string with 501 characters
        And I click the "Update" button
        Then I should see "Character limit exceeded (500)"