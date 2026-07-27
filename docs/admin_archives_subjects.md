# Feature: Admin archives subjects

## User Story
As an **Admin**, I want to **archive subjects instead of permanently deleting them** so that **obsolete subjects are removed from use without breaking existing sessions or historical data**.

## Acceptance Criteria
1. **Happy path:** When I visit **Manage Subjects**, clicking **Delete** archives a subject and shows **“Subject was successfully archived.”**
2. **Hidden from tutors:** Archived subjects do **not appear** in the **Create Session** subject dropdown.
3. **Hidden from learners:** Archived subjects do **not appear** in the **Find a Session** subject dropdown.
4. **Data preserved:** Existing sessions that used the archived subject still show the subject name on the session’s page.
5. **Access control:** Non-admin users are redirected to the login page when attempting to access **Manage Subjects**.

## MVC Outline

### Models
- A **Subject model** with:
  - `name:string`
  - `code:string`
  - `description:text`
  - `archived:boolean` (default: `false`)
- A **TutorSession model** with:
  - `subject:references`
  - `tutor:references`
  - `start_at:datetime`
  - `end_at:datetime`
  - `capacity:integer`
  - `status:string`
- A **SessionAttendee model** with:
  - `tutor_session:references`
  - `learner:references`

### Views
- A **subjects/index.html.erb** view that lists all subjects and provides a **Delete** button for admins to archive them.
- A **sessions/new.html.erb** view with a subject dropdown that lists **only active subjects**.
- A **sessions/search.html.erb** view with a subject dropdown that lists **only active subjects**.
- A **sessions/show.html.erb** view where archived subjects remain visible for existing sessions.

### Controllers
- A **SubjectsController** with:
  - `index` action to display subjects
  - `destroy` action to archive subjects
- A **SessionsController** with:
  - `search` and `results` actions to filter sessions by subject
  - `new` and `create` actions for tutors to create sessions
  - updated filtering logic to exclude archived subjects from dropdowns
