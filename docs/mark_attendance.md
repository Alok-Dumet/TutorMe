# Feature: Tutor marks a learner's attendance for a tutoring session

## User Story
As a **Tutor**, I want to **mark a learner's attendance for a tutoring session** so that **the learner and I can both keep track of their session attendance**.

## Acceptance Criteria
1. **Happy path**: If I mark a learner as present, I see a "Learner marked as present" confirmation message
2. **Absent tutee**: If I mark a learner as absent, I see a "Learner marked as absent" confirmation message
3. **No selection**: If I try to save attendance with no attendance options selected, the action is rejected with a "No attendance option selected." error message
4. **Future attendance**: If a session has not yet occurred, the attendance marking functionality is disabled

## MVC Outline
### Models
- A **Learner model** with `first_name:string` and `last_name:string` attributes.
- A **Tutor model** with `learner:references` attribute.
- A **TutorSession model** with `tutor:references`, `start_at:datetime`, and `end_at:datetime` attributes.
- A **SessionAttendee model** with `session:references`, `learner:references`, `attended:boolean`, and `cancelled:boolean` attributes.

### Views
- A **sessions/show.html.erb** that shows the details of a session (including the attendance function).

### Controllers
- A **SessionsController** with the `show` action.
