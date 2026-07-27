# Feature: Learner browses tutors and filters by Subject

## User Story
As a **Learner (Tutee)**, I want to **see a list of tutors, filter the list by subject, and open a tutor’s profile** so that **I can quickly find the right tutor for my needs**.

## Acceptance Criteria
1. **Happy path:** After I sign in and visit **All Tutors**, clicking a tutor’s name shows their profile with **Bio**, **Rating**, **Rating count**, and **Subjects**.
2. **Filter by subject:** When I choose a subject and search, I only see tutors who teach that subject; tutors for other subjects are hidden.
3. **Blank subject:** If I press **Search** without selecting a subject, I see **“Please select a subject”**.
4. **Default listing:** Visiting **/tutors** with no subject filter shows **all tutors**.

## MVC Outline
### Models
- A **Learner model** with `email:string`, `password:string`, `first_name:string`, and `last_name:string` attributes.
- A **Tutor model** with `learner:references`, `bio:text`, `rating_avg:decimal{3,2}`, and `rating_count:integer` attributes.
- A **Subject model** with `name:string` attribute.
- A **Teach model** with `tutor_id:integer` and `subject_id:integer` attributes.

### Views
- A **home/index.html.erb view** with a **“View Tutors”** link for signed-in learners.
- A **tutors/index.html.erb view** with a subject filter form and a list of tutor **names** linking to profiles; shows **“Please select a subject”** if submitted blank.
- A **tutors/show.html.erb view** that displays the tutor’s name and a **Details** list (Bio, Rating, Rating count) and a **Subjects** list.

### Controllers
- A **HomeController** with `index` action.
- A **TutorsController** with `index` and `show` actions.