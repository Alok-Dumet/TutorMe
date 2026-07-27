# 🎓 TutorMe – Peer-to-Peer Academic Support Platform

## 📌 Project Overview
**TutorMe** is a Ruby on Rails–powered Software-as-a-Service (SaaS) platform designed to centralize peer-to-peer academic support.The system connects students seeking help with approved student tutors, facilitating the coordination of online session scheduling and post-session feedback.

The platform serves three distinct user groups—Learners, Tutors, and Admins—providing a robust user management system with distinct roles, permissions, and a modular architecture.

This project was developed for:
* **Course:** CS-UY 4513 – Software Engineering
* **Professor:** Dr. DePasquale
* **Semester:** Fall 2025

## 👥 Team Members & Contributions

* **Edward Kim** – User Authentication, Learner Session Management (View/Cancel), CI (SimpleCov).
* **Ivan Yeung** – Learner Booking Logic, Meeting Link Management.
* **Abdulrahman Albaoud** – Learner Feedback System, Admin Subject Management.
* **Remi Uy** – Tutor Availability Slots, Tutor Session Management (View/Cancel).
* **Alok Aenugu** – Tutor Application Submission, Admin Approval Workflows.
* **Alan Tong** – Attendance Tracking, Tutor Profile Management, Admin Approval Workflows.
* **Jungwoo Park** – Tutor Feedback Views, Admin Privilege Management.

## 🚀 Features

### User & Identity Management
* **Authentication:** Secure registration and login for Learners via email/password.
* **Roles:** Distinct permissions for Learners, Tutors (approved learners), and Admins.
* **Tutor Applications:** Workflow for Learners to apply to become Tutors, with Admin approval/rejection capabilities.

### Scheduling & Session Management
* **Availability:** Tutors publish available time slots (sessions) with specific capacities, subjects, and meeting links.
* **Booking:** Learners search for sessions by Subject and Time Range and "instant-book" slots.
* **Attendance:** Tutors mark Learners as "Present" or "Absent" after meetings to unlock the feedback cycle.
* **Cancellations:** Lifecycle management allowing Learners to cancel bookings and Tutors to cancel entire sessions.

### Tutor & Subject Catalog
* **Browsing:** Learners can search for sessions by specific subjects.
* **Profiles:** Tutors can manage their bios to showcase their qualifications.
* **Subject Management:** Admins can create and archive subjects to keep the catalog relevant.

### Feedback & Reporting
* **Ratings:** Learners submit 1-5 star ratings and comments for sessions they attended.
* **Analytics:** Tutors can view their own feedback history and aggregate ratings.

## 🛠️ Tech Stack
* **Language:** Ruby 3.4.7
* **Framework:** Ruby on Rails 8.0
* **Database:** PostgreSQL
* **Testing:** RSpec (Unit/Request specs), Cucumber (Behavior-Driven Development), Capybara

## 📡 API & Routes Overview
The application exposes a RESTful interface. Below are the key endpoints based on the current implementation:

### 🔐 Authentication
* `POST /login` — Log in a user (Learner or Admin).
* `POST /learners` — Register a new learner account.
* `DELETE /logout` — End the current session.

### 📚 Tutors & Applications
* `GET /tutors` — List all tutors (supports subject filtering).
* `GET /tutors/:id` — View specific tutor profile.
* `POST /tutor_applications` — Submit a new application to become a tutor.
* `GET /admin/tutor_applications/pending` — Admin view of pending applications.
* `POST /admin/tutor_applications/:id/approve` — Admin approves a tutor.
* `POST /admin/tutor_applications/:id/reject` — Admin rejects a tutor application.

### 📅 Sessions & Booking
* `GET /sessions/search` — Form to search for available tutor slots.
* `GET /sessions/results` — Display search results based on subject/time.
* `POST /sessions/:id/book` — Book a specific session slot.
* `PATCH /sessions/:id` — Tutor marks attendance (Present/Absent).
* `GET /learner_sessions` — View logged-in learner's upcoming bookings.
* `GET /tutor_sessions` — View logged-in tutor's scheduled sessions.
* `PATCH /learner_sessions/:id/confirm_cancel` — Learner cancels a booking.
* `PATCH /tutor_sessions/:id/confirm_cancel` — Tutor cancels an entire session.

### 💬 Feedback
* `POST /sessions/:session_id/feedbacks` — Submit feedback for a completed, attended session.
* `GET /tutor/feedbacks` — Tutors view their received feedback.

### 🔧 Administration
* `POST /subjects` — Admin creates a new subject.
* `DELETE /subjects/:id` — Admin archives a subject.

## ⚙️ Setup Instructions

Follow these instructions to get the project up and running on your local machine.

### 1. Requirements
* **Ruby:** 3.4.7
* **Rails:** 8.0.x
* **PostgreSQL:** 14+

### 2. Clone Repository
```bash
git clone https://github.com/NYU-CSE-Software-Engineering/cs-uy-4513-f25-team2.git
cd cs-uy-4513-f25-team2/
```

### 3. Install Dependencies
```bash
bundle install
```

### 4. Setup the Database

This command will create the database, run migrations, and seed it with initial data.

```bash
rails db:create
rails db:migrate
rails db:seed
```

### 5. Run the server
```bash
rails server
```

Access the application at http://localhost:3000.

## 🧪 Testing Instructions

The project maintains a comprehensive test suite using RSpec for unit/request tests and Cucumber for acceptance tests.

### Run Unit & Request Tests (RSpec)

Use RSpec to verify models, validations, controller logic, and API endpoints.

```bash
bundle exec rspec
```

### Run End-to-End Tests (Cucumber)

To verify full user journeys (e.g., A learner browsing, booking, and submitting feedback):

```bash
bundle exec cucumber
```
