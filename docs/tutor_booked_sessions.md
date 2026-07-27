# Feature: Tutor views upcoming and past booked sessions

## User Story
As a **signed-in tutor**, I want to **view my upcoming and past tutoring sessions** so that **I can manage my schedule and view sessions**.

## Acceptance Criteria
1. **Happy path (Upcoming):** When I click "View My Sessions (Tutor)", I see a list of my upcoming sessions with Subject, Capacity, Time, and Status.
2. **Happy path (Past):** When I click "View past sessions", I see my past/completed sessions.
3. **No upcoming sessions:** If I have no upcoming sessions, I see "You have no upcoming sessions."
4. **No past sessions:** If I have no past sessions, I see "You have no past sessions."
5. **Access control:** Unauthenticated users or non-tutors cannot access these pages.

## MVC Outline
### Models
- A **Tutor model** associated with the current learner.
- A **TutorSession model** with scopes to filter by `tutor_id` and time (`start_at` vs `Time.current`).

### Views
- A **tutor_sessions/index.html.erb** view listing upcoming sessions with "Edit", "Details", and "Cancel" actions.
- A **tutor_sessions/past.html.erb** view listing past sessions with a "Details" link.

### Controllers
- A **TutorSessionsController** with `index` and `past` actions.