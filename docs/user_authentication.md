# Feature: User Authentication (login, signup, logout)

## User Story:
As a learner, I want to create an account, log in, and log out, so that I can access the features of the app in the correct role.

## Acceptance Criterion:
1. The user can sign up and create a new account with a valid email and password.
2. The user cannot sign up without an email or password or if they sign up with an email that is already in use.
3. A registered user can log in with valid credentials and will be redirected to their home page.
4. An error is displayed if login credentials are invalid.
5. A logged-in user can log out and be redirected to the login page.

## MVC Components:
### Models
- A **Learner model** with `email:string`, `password:string`, `first_name:string`, and `last_name:string` attributes.

### Views
- `learners/new.html.erb` - Signup Page with a email form and a password form.
- `logins/new.html.erb` - Login Page with an email form and a password form.
- `home/index.html.erb` - Home Page that includes a logout button.

### Controllers
- `LearnersController#new, create` - displays signup form, creates new account.
- `LoginsController#new, create, delete` - displays login form, creates login-session, deletes login session.
- `HomeController#index` - displays initial page when user successfully logins.