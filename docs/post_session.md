# Feature: Tutor posts sessions

## User Story (Connextra)
As a **Tutor**
So that **I can have learners sign up for one-on-one sessions**
I want to **post sessions** ## Acceptance Criteria (SMART)
1. **Happy path:** I post my availability to the Tutor Catalog along with times, capacity, and subject. I am redirected to my upcoming sessions list and see "Session successfully created".
2. **Unknown information:** If I do not fully fill out all the information for the session, creation is rejected with validation error messages.
3. **Overlapping slots:** If I try to create a session that overlaps with one of my existing sessions, creation is rejected with a "Session overlaps with existing session" message.
4. **Cancel slots:** If I view my upcoming sessions, I can "Cancel" a session. (Note: Sessions are cancelled, not fully deleted from the database).

## MVC Outline
### Models
- A **Tutor model** with `learner:references` attribute.
- A **Learner model**.
- A **Subject model**.
- A **TutorSession model** with `tutor:references`, `subject:references`, `start_at:datetime`, `end_at:datetime`, `capacity:integer`, `status:string`, and `meeting_link:string`.

### Controllers
- A **SessionsController** with `new` and `create` actions (for creating the session).
- A **TutorSessionsController** with `index` and `cancel` actions (for managing the posted sessions).

### Views
- A **sessions/new.html.erb** with fields for a new tutoring session.
- A **tutor_sessions/index.html.erb** for the tutor to view their posted sessions.