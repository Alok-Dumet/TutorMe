# Feature: Tutor views feedback received from learners

## User Story
As a **Tutor**, I want to **see all ratings and comments I’ve received from learners** so that **I can evaluate my performance and improve future sessions**.

> **Assumption:** All scenarios assume the user is already authenticated as an **approved Tutor** (“Given I am a signed-in tutor”).

## Acceptance Criteria
1. **Happy path:** When I visit my Feedback page, I see a list of all feedback with the learner’s name, rating, comment, subject, and session date, plus **Average Rating** and **Total Reviews**.
2. **No feedback yet:** If I have not received any feedback, I see “No feedback yet.”
3. **Access control:** A tutor can only view their own feedback; accessing another tutor’s feedback returns “Access denied.”
4. **Filtering:** I can filter my feedback by subject or date range, and only matching results are shown (summary stats update).
5. **Pagination:** Feedback appears with the most recent first, limited to a page size (e.g., 10 per page).
6. **Visibility rule:** Only feedback from sessions that have **ended** and where the learner was **marked attended** (and submitted feedback) are shown.

## MVC Outline

### Models
- **Tutor** (`learner:references`, `bio:text`, `photo_url:string`, `rating_avg:decimal`, `rating_count:integer`)
  - `has_many :sessions`
  - `has_many :feedback`
- **TutorSession** (`tutor_id:integer`, `subject_id:integer`, `start_at:datetime`, `end_at:datetime`, `status:string`, `meeting_link:text`, `capacity:integer`)
  - `belongs_to :tutor`
  - `belongs_to :subject`
  - `has_many :feedback`
- **Feedback** (`session_id:integer`, `learner_id:integer`, `tutor_id:integer`, `score:integer`, `comment:text`, `created_at:datetime`)
  - `belongs_to :session`
  - `belongs_to :learner`
  - `belongs_to :tutor`
  - Scopes:
    - `.for_tutor(tutor_id)`
    - `.visible` (completed session + attended via SessionAttendee)
- **Subject** (`name:string`, `code:string`)
  - Used to label feedback by subject

### Views
- **`tutors/feedbacks/index.html.erb`**
  - Summary (Average Rating / Total Reviews)
  - Filters (Subject, Date range)
  - List of feedback rows (date, subject, score, comment) with CSS hooks:
    - `.feedback-row`, `.feedback-date`
  - Empty state: “No feedback yet”
  - Pagination controls: `.pagination`

### Controllers
- **`Tutors::FeedbacksController#index`**
  - Auth: approved tutor required
  - Loads feedback for `current_tutor` only
  - Applies `.visible`, filters (subject/date), orders newest first, paginates (10/page)
  - Computes filtered **avg** and **count**
  - Renders `index.html.erb`

### Example Routes
```ruby
namespace :tutor do
  resources :feedbacks, only: [:index]   # GET /tutor/feedbacks
end

namespace :api do
  resources :tutors, only: [] do
    get :feedback, on: :member           # GET /api/tutors/:id/feedback
  end
end
