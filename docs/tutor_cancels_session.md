# Feature: Tutor cancels a tutoring session

## User Story
As a **signed-in tutor**, I want to **cancel an upcoming tutoring session** so that **I can free up my time**.

## Acceptance Criteria
1. **Happy path:** I can click "Cancel" on an upcoming session, see a confirmation page, confirm the action, and see the session status update to "cancelled".
2. **Abort cancellation:** I can choose not to cancel and return to the session list.
3. **Unauthorized access:** I cannot cancel another tutor's session.
4. **Past sessions:** I cannot cancel a session that has already occurred.

## MVC Outline
### Models
- A **TutorSession model** with a `status:string` attribute (updates to "cancelled").

### Views
- A **tutor_sessions/cancel.html.erb** view with session details and a confirmation prompt.

### Controllers
- A **TutorSessionsController** with:
  - `cancel` action (GET) to show the confirmation page.
  - `confirm_cancel` action (PATCH) to update the status.