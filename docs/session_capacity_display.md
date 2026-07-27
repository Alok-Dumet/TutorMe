# Feature: Show remaining seats for tutoring sessions

## User Story
As a **signed-in learner**, I want to **see how many seats are left in each session** so that **I can choose sessions that are not already full**.

## Acceptance Criteria
1. **Seats remaining:** The number of available seats (e.g., "2 / 3") is displayed in the search results and on the session details page.
2. **Full session:** If a session is full, it is marked as "Full" and cannot be booked.
3. **Dynamic updates:** Cancelling a booking increases the seats remaining count for that session immediately.

## MVC Outline
### Models
- A **TutorSession model** with:
  - `capacity:integer`
  - Methods to calculate `seats_remaining` and check if `full?` based on non-cancelled `session_attendees`.

### Views
- A **sessions/results.html.erb** view displaying "Seats remaining" or a "Full" badge for each result.
- A **sessions/show.html.erb** view displaying "Seats remaining" or a "Full" badge in the session details list.

### Controllers
- A **SessionsController** that loads session data including capacity and attendees for the `results` and `show` actions.