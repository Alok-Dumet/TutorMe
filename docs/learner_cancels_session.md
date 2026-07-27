# Feature: Learner cancels an upcoming booked session

## User Story
As a **signed-in learner**, I want to **cancel an upcoming tutoring session** so that **I can free up my time and allow others to book that slot**.

## Acceptance Criteria
1. **Happy path:** I can click "Cancel" on an upcoming session, see a confirmation page with session details, confirm the cancellation, and see a "Session cancelled" message.
2. **Abort cancellation:** If I choose "No" on the confirmation page, the session is not cancelled, and I am returned to the upcoming sessions list.
3. **Unauthorized access:** I cannot cancel another learner's booking; attempting to do so shows "You are not authorized to cancel that session."
4. **Past sessions:** I cannot cancel a past session; attempting to do so shows "You can only cancel upcoming sessions."

## MVC Outline
### Models
- A **SessionAttendee model** with a `cancelled:boolean` attribute.
- A **TutorSession model** associated with the booking.

### Views
- A **learner_sessions/cancel.html.erb** view that displays the session subject, tutor, and time, asking "Are you sure you want to cancel this session?" with Yes/No buttons.

### Controllers
- A **LearnerSessionsController** with:
  - `cancel` action (GET) to show the confirmation page.
  - `confirm_cancel` action (PATCH) to update the `cancelled` status.