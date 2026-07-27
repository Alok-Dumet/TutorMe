# Feature: Tutor updates session link

## User Story
As a **Tutor**, I want to **update the meeting link for my tutor sessions** so that **I can fix mistakes on my session**.

## Acceptance Criteria
1. **Happy path:** I can click "Edit" on an upcoming session, enter a new meeting link, update, and see the new link on the session list.
2. **No changes:** I can cancel the update process and return to the list without changes.
3. **Unauthorized access:** I cannot edit another tutor's session; doing so shows "You cannot edit another tutor's session."
4. **Past sessions:** I cannot edit a past session; doing so shows "You can only edit upcoming sessions."

## MVC Outline
### Models
- A **TutorSession model** with a `meeting_link:string` attribute.

### Views
- A **tutor_sessions/edit.html.erb** view with a form to update the `meeting_link`.

### Controllers
- A **TutorSessionsController** with `edit` and `update` actions.