# Feature: Tutor updates their bio

## User Story
As a **Tutor**, I want to **update my bio** so that **I can keep my information up-to-date for learners**.

## Acceptance Criteria
1. **Happy path:** After I sign in and click **"Update my Profile"**, I can change my bio and see a **"Changes saved"** confirmation message, and the updated bio is visible on my tutor profile page.
2. **No changes:** If I click **"Update"** without modifying the bio, I see a **"No changes made"** message.
3. **Empty bio:** If I update my bio to be empty, I see **"No bio has been provided."** on my profile page.
4. **Character limit:** If I try to enter a bio that exceeds 500 characters, I see an error message **"Character limit exceeded (500)"**.

## MVC Outline
### Models
- A **Tutor model** with `learner:references`, `bio:text`, `rating_avg:decimal{3,2}`, and `rating_count:integer` attributes.

### Views
- A **home/index.html.erb view** with an **"Update my Profile"** link for signed-in tutors.
- A **tutors/edit.html.erb view** with a form to update the bio (and other profile information).
- A **tutors/show.html.erb view** that displays the tutor's bio or **"No bio has been provided."** if the bio is empty.

### Controllers
- A **TutorsController** with the `edit` and `update` actions.
