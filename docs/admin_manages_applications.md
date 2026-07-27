# Feature: Admin approves or rejects tutor applications

## User Story
As an **Admin**, I want to **approve or reject a submitted tutor application** so that **I can manage the active list of tutors**.

## Acceptance Criteria
1. **Happy path**: If I approve a tutor application, I see an "Application approved" message, the pending application is no longer present on the page, and the learner is now a tutor
2. **Reject application**: If I reject a tutor application, I see an "Application rejected" message, the pending application is no longer present on the page, and the learner is not a tutor
3. **No selection**: If I press "Confirm" without selecting an approval option, I see a "No option selected." error message
4. **No pending applications**: If there are no pending applications, I see a "There are no pending applications to review." message

## MVC Outline
### Models
- A **TutorApplication model** with `learner:references`, `reason:string` and `status:string` attributes.

### Views
- A **applications/pending.html.erb** that shows a list of all pending tutor applications (including the approve/deny function for each).

### Controllers
- An **ApplicationsController** with the `pending` action.
