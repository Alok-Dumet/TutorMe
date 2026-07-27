# Feature: Learner views upcoming and past booked sessions

## User Story
As a **signed-in learner**, I want to **view my upcoming and past tutoring sessions** so that **I can manage my schedule and review my learning**.

## Acceptance Criteria
1. **Happy path (Upcoming):** When I click "View My Sessions", I see a list of my upcoming "scheduled" sessions with the Subject, Tutor Name, and status, but I do not see past or other learners' sessions.
2. **Happy path (Past):** When I click "View past sessions", I see my completed sessions with attendance status (Present/Absent/Not recorded) and links to leave feedback if attended.
3. **No upcoming sessions:** If I have no upcoming sessions, I see the message "You have no upcoming sessions."
4. **No past sessions:** If I have no past sessions, I see the message "You have no past sessions."
5. **Access control:** Unauthenticated users attempting to access these pages are redirected to the login page.

## MVC Outline
### Models
- A **Learner model** with `email:string` and `first_name:string`.
- A **SessionAttendee model** with `tutor_session:references`, `learner:references`, `attended:boolean`, and `cancelled:boolean`.
- A **TutorSession model** with `subject:references`, `tutor:references`, `start_at:datetime`, `end_at:datetime`, and `status:string`.

### Views
- A **learner_sessions/index.html.erb** view that lists upcoming bookings and provides a link to past sessions.
- A **learner_sessions/past.html.erb** view that lists past bookings with attendance badges and feedback links.

### Controllers
- A **LearnerSessionsController** with `index` and `past` actions.