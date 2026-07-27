Feature: Learner views tutor profiles
  As a signed-in learner
  I want to view tutor profiles and filter by subject
  So I can find the right tutor

  Background:
    Given I am a signed-in learner
    And the following tutors exist:
      | tutor_name     | bio    | rating_avg | rating_count | subjects                            |
      | Emily Johnson  | Hey.   | 4.7        | 13           | Calculus, Biology                   |
      | Sarah Miller   | Hi.    | 4.6        | 6            | Calculus                            |
      | Michael Chen   | Hello. | 4.1        | 45           | Statistics, Chemistry, Programming  |

  @happy_views_profile
  Scenario: View a tutor profile from the list
    Given I am on the "All Tutors" page
    When I click on "Michael Chen"
    Then I should see "Michael Chen"
    And I should see "Hello."
    And I should see "4.1"
    And I should see "45"
    And I should see "Statistics"
    And I should see "Chemistry"
    And I should see "Programming"

  @happy_searches_profiles
  Scenario: Filter tutors by subject
    Given I am on the "All Tutors" page
    When I filter tutors by subject "Calculus"
    Then I should see the following tutors: "Emily Johnson", "Sarah Miller"
    And I should not see the following tutors: "Michael Chen"

  @sad_missing_subject
  Scenario: Pressing search without selecting a subject
    Given I am on the "All Tutors" page
    When I attempt to filter tutors without selecting a subject
    Then I should see "Please select a subject"