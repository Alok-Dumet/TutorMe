# Feature: Learner Sumbits feedback after a session

### User Story (Connextra)
as a **Learner**
I want to **submit feedback about my tutoring session**,
So that I can **share my experience with my tutor to help others**.


## Acceptance Criteria (SMART)
1. **Happy path:** From the session summary page, I can open the feedback form, enter a comment and rating, submit it, and see a confirmation message.  
2. **Missing comment:** If I submit without a comment, I see “Comment can’t be blank.”
3. **Missing rating:** If I submit without a rating, I see “Rating can’t be blank.” 
4. **Multiple feedbacks:** If I already submitted feedback for a session, I cannot submit another.
5. **Feedback display:** After submission, I can view my feedback in the “My Feedback” section.
6. **Attendance gate:** I can only see or submit the feedback form if I was marked present for the session by the tutor; otherwise the form is hidden and I see “You were not marked present for this session.”


## MVC Outline
### Models
- `Tutor(id, first_name, last_name, ...)`
- `Learner(id, first_name, last_name, ...)`
- `Feedback(id, session_id, learner_id, ...)`
- `TutorSession((id, tutor_id, subject_id, ...)`
- `SessionsAttendee(id, session_id, learner_id, joined_at, attended, feedback_submitted, cancelled_at)`


### Controllers
- `FeedbacksController#new, create, index, show` —  
  `new` renders the feedback form for a learner after a session is completed.  
  `create` saves the learner’s feedback, validates presence of rating and comment, and redirects to confirmation or an error page.  
  `index` displays all feedback the learner has submitted, accessible only to learners 
  `show` shows details for a specific feedback entry.  

### Views
- `feedbacks/new.html.erb` — form for learners to submit feedback after a session.  
- `feedbacks/index.html.erb` — view for learners to view all feedback they have sent.  
- `feedbacks/show.html.erb` — confirmation view showing individual feedback.  
