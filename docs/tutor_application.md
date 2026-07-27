# Feature: Allow a user to apply to be a tutor

## User Story (Connextra)
As a **Learner**  
So that **I can access tutor privileges, like reserving a room and booking a session**  
I want to **apply to be a tutor**

## Acceptance Criteria (SMART)
1. **Happy path:** From the Home page, I view the option to apply to be a tutor, go to an Application page, fill out an application, submit my application, and see a confirmation message.  
2. **Already a tutor:** From the Home page, if I am already a tutor, the option to apply is hidden.  
3. **Pending review:** From the Home page, if my application is pending, the option to apply is replaced with a “Pending review” message.

## MVC Outline
### Models
- A **Learner model** with `email:string`, `password:string`, `first_name:string`, and `last_name:string` attributes.
- A **Tutor model** with `first_name:string`, `last_name:string`, and `email:string` attributes.
- A **TutorApplication model** with `id`, `learner_id`, `reason`, and `status` attributes.

### Views
- A **tutors/application.html.erb view** with a form to submit your reason for applying.
- A **settings.html.erb view** that will conditionally render a button to apply for being a tutor or a "pending review" message.

### Controllers
- An **TutorApplicationsController** with `new`, `create` actions.