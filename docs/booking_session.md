# Feature: Learner finds a posted session by Subject + Time Range and books it

## User Story
As a **Learner (Tutee)**, I want to **search tutors’ posted sessions by subject and time range and book one** so that **I can attend an online tutoring session at a convenient time**.

## Acceptance Criteria
1. **Happy path:** After I sign in and search by subject and time range, I see matching sessions; choosing one and confirming shows “Booking confirmed” and a meeting link.
2. **No double-booking:** If I try to book the same session twice, I see “You are already booked for that session.”
3. **Capacity enforced:** If a session is full, I see “This session is full.”
4. **Time conflict:** If my chosen session overlaps another upcoming session of mine, I see “This session conflicts with another session.”
5. **Auditability:** A successful booking creates a `SessionAttendee` linking me (learner) to the chosen session, and the session has a meeting link.
6. **No self-booking:** If I try to book a session that I am the tutor for, I see "You cannot book your own session"

## MVC Outline
### Models
- A **Learner model** with `email:string`, `password:string`, `first_name:string`, and `last_name:string` attributes.
- A **Tutor model** with `learner:references` attribute (to display the tutor’s name via the linked learner).
- A **Subject model** with `name:string` attribute.
- A **Teach model** with `tutor_id:integer` and `subject_id:integer` attributes.
- A **TutorSession model** with `tutor_id:integer`, `subject_id:integer`, `start_at:datetime`, `end_at:datetime`, `capacity:integer`, and `meeting_link:text` attributes.
- A **SessionAttendee model** with `session_id:integer` and `learner_id:integer` attributes.

### Views
- A **home/index.html.erb view** with a link to begin searching.
- A **sessions/search.html.erb view** with a form.
- A **sessions/results.html.erb view** with a list of matching sessions and a select button per session.
- A **sessions/confirm.html.erb view** with a confirm button.

### Controllers
- A **HomeController** with `index` action.
- A **SessionsController** with `search`, `results`, and `confirm` actions.
