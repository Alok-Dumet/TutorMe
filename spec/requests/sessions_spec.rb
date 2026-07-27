require 'rails_helper'
require 'cgi'

RSpec.describe "Sessions", type: :request do
  let(:learner) { create(:learner) }

  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_learner).and_return(learner)
  end

  describe "GET /sessions/search" do
    it "renders the search page" do
      get search_sessions_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Find a Session")
    end
  end

  describe "GET /sessions/results" do
    let!(:calculus) { create(:subject, name: 'Calculus') }
    let(:base_day) { 1.week.from_now.change(hour: 10, min: 0, sec: 0) }
    let!(:session1) { create(:tutor_session, subject: calculus, start_at: base_day, end_at: base_day + 1.hour) }

    it "returns matching sessions within time range" do
      session2 = create(:tutor_session, subject: calculus, start_at: base_day + 4.hours, end_at: base_day + 5.hours)

      get results_sessions_path, params: {
        subject: 'Calculus',
        start_at: (base_day - 2.hours).iso8601,
        end_at: (base_day + 10.hours).iso8601
      }

      expect(response).to have_http_status(:ok)
      expect(assigns(:sessions)).to match_array([session1, session2])
    end

    it "handles invalid date formats gracefully (Sad Path)" do
      get results_sessions_path, params: {
        subject: 'Calculus',
        start_at: 'invalid-date-string',
        end_at: 'another-bad-date'
      }
      expect(response).to have_http_status(:ok)
      expect(assigns(:sessions)).to include(session1)
    end

    it "returns empty if subject does not exist" do
      get results_sessions_path, params: { subject: 'NonExistent' }
      expect(response).to have_http_status(:ok)
      expect(flash[:alert]).to include("No such subject")
    end

    it "alerts if subject is blank" do
      get results_sessions_path, params: { subject: '' }
      expect(response).to have_http_status(:ok)
      expect(flash[:alert]).to include("Please select a subject")
    end
  end

  describe "POST /sessions/:id/book" do
    it "creates a booking and redirects with success message" do
      session = create(:tutor_session)

      expect {
        post book_session_path(session)
      }.to change(SessionAttendee, :count).by(1)

      expect(response).to redirect_to(learner_sessions_path)
      expect(flash[:notice]).to eq("Booking confirmed")
    end

    it "shows error when learner already booked" do
      session = create(:tutor_session)
      create(:session_attendee, tutor_session: session, learner: learner)

      post book_session_path(session)

      expect(flash[:alert]).to eq("You are already booked for that session")
    end

    it "shows error when session is full" do
      session = create(:tutor_session, capacity: 1)
      create(:session_attendee, tutor_session: session) # someone else

      post book_session_path(session)
      expect(flash[:alert]).to eq("This session is full")
    end

    it "prevents a tutor from booking their own session (Edge Case)" do
      tutor = create(:tutor)
      session = create(:tutor_session, tutor: tutor)
      
      allow_any_instance_of(ApplicationController).to receive(:current_learner).and_return(tutor.learner)
      allow_any_instance_of(ApplicationController).to receive(:current_tutor).and_return(tutor)

      post book_session_path(session)

      expect(response).to redirect_to(confirm_session_path(session))
      expect(flash[:alert]).to eq("You cannot book your own session")
    end
  end

  describe "PATCH /sessions/:id (Attendance)" do
    let(:tutor) { create(:tutor) }
    let(:session) { create(:tutor_session, tutor: tutor, start_at: 1.day.ago) }
    
    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(tutor.learner)
    end

    it "marks learner as present" do
      learner_student = create(:learner)
      patch session_path(session), params: {
        session_attendee: { learner_id: learner_student.id, attended: "true" }
      }
      
      expect(SessionAttendee.last.attended).to be(true)
      expect(response).to redirect_to(session_path(session))
    end

    it "fails gracefully if saving attendance fails (Sad Path)" do
      learner_student = create(:learner)
      
      allow_any_instance_of(SessionAttendee).to receive(:save).and_return(false)

      patch session_path(session), params: {
        session_attendee: { learner_id: learner_student.id, attended: "true" }
      }

      expect(flash[:alert]).to eq("Failed to save attendance.")
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "POST /sessions (Create)" do
    let(:tutor) { create(:tutor) }
    let(:subject) { create(:subject) }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(tutor.learner)
      allow_any_instance_of(ApplicationController)
        .to receive(:current_tutor).and_return(tutor)
    end

    it "creates a new session" do
      expect {
        post "/sessions", params: {
          tutor_session: {
            subject_id: subject.id,
            start_at: '2026-10-15T10:00',
            capacity: 1,
            meeting_link: 'https://zoom.us/new'
          },
          duration_hours: 1,
          duration_minutes: 0
        }
      }.to change(TutorSession, :count).by(1)
      
      expect(response).to redirect_to(tutor_sessions_path)
    end

    it "creates a new session with a new Subject name" do
      expect {
        post "/sessions", params: {
          tutor_session: {
            subject: "NewSubject",
            start_at: '2026-10-15T10:00',
            capacity: 1,
            meeting_link: 'https://zoom.us/new'
          },
          duration_hours: 1,
          duration_minutes: 0
        }
      }.to change(Subject, :count).by(1)
    end
  end
end