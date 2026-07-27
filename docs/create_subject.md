# Feature: Admin adds a new subject

## User Story
As an **Admin**, I want to **create a subject with a name and unique code** so that **tutors and sessions can consistently reference standardized subjects**.

## Acceptance Criteria
1. **Happy path:** After I sign in as an admin and submit a valid **Name** and unique **Code**, I am redirected back to the New Subject page and see the message "Subject created: [Name] ([Code])".
2. **Missing code:** If I submit without a **Code**, I remain on the form and see "Code can't be blank."
3. **Missing name:** If I submit without a **Name**, I remain on the form and see "Name can't be blank."
4. **Duplicate code:** If I submit a **Code** that already exists (case-insensitive), I remain on the form and see "Code has already been taken."

## MVC Outline
### Models
- A **Subject model** with `name:string` and `code:string` attributes.

### Views
- A **home/index.html.erb** view with a link for admins to begin adding a new subject.
- A **subjects/new.html.erb** view with a form for **Name** and **Code**, showing inline validation errors and the success notice after creation.

### Controllers
- A **HomeController** with `index` action.
- A **SubjectsController** with `new` and `create` actions (admin-only).
- An **ApplicationController** that provides `current_admin` and enforces `require_admin` for admin-only routes.