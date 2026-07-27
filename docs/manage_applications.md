# Feature: Admin approves or rejects tutor applications

## User Story
As an **Admin**, I want to **approve or reject a submitted tutor application** so that **I can manage the active list of tutors**.

## Acceptance Criteria
1. **Happy path**: On the tutor applications page, if I approve a tutor application, I see an "Application approved successfully" message, the pending application is no longer present on the page, and the learner is now a tutor.
2. **Reject application**: If I reject a tutor application, I see an "Application rejected" message, the pending application is no longer present on the page, and the learner's application is deleted.
3. **Already approved**: If an approve or reject request is made for a user who is already a tutor, an "Learner is already Tutor" error message is shown.
4. **Not real**: If an approve or reject request is made for a user who does not exist, an "Invalid Learner was passed" error message is shown.
5. **No pending applications**: If there are no pending applications, I see a "There are no pending applications to review" message.

## MVC Outline
### Models
- A **TutorApplication model** with `id`, `learner_id`, `reason`, and `status` attributes.
- A **Tutor model** with `learner:references` attribute.
- A **Learner model** with `email:string`, `password:string`, `first_name:string`, and `last_name:string` attributes.

### Views
- A **admin/tutor_applications/pending.html.erb** that shows a list of all pending tutor applications (including approve and deny buttons).

### Controllers
- An **Admin::TutorApplicationsController** with `pending` (index), `approve`, and `reject` actions.