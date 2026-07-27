require 'rails_helper'

RSpec.describe 'LearnerSessions', type: :request do
  let(:learner) { create(:learner) }

  def log_in_as(learner)
    post login_path, params: { email: learner.email, password: learner.password }
  end

  describe 'GET /learner_sessions' do
    it 'redirects to login when not signed in' do
      get learner_sessions_path
      expect(response).to redirect_to(new_login_path)
    end

    it 'shows only upcoming bookings for the current learner' do
      upcoming_session = create(:tutor_session, start_at: 2.days.from_now, subject: create(:subject, name: 'Calculus'))
      past_session = create(:tutor_session, start_at: 2.days.ago, subject: create(:subject, name: 'Biology'))

      create(:session_attendee, tutor_session: upcoming_session, learner: learner)
      create(:session_attendee, tutor_session: past_session, learner: learner)
      create(:session_attendee, tutor_session: upcoming_session) # Another learner

      log_in_as(learner)
      get learner_sessions_path

      expect(response.body).to include('Calculus')
      expect(response.body).not_to include('Biology')
    end

    it 'shows a friendly message when there are no upcoming sessions' do
      log_in_as(learner)
      get learner_sessions_path
      expect(response.body).to include('You have no upcoming sessions.')
    end
  end

  describe 'GET /learner_sessions/past' do
    it 'shows past bookings' do
      present_session = create(:tutor_session, start_at: 2.days.ago, status: 'completed')
      create(:session_attendee, tutor_session: present_session, learner: learner, attended: true)

      log_in_as(learner)
      get past_learner_sessions_path

      expect(response.body).to include('Present')
    end
  end

  describe 'GET /learner_sessions/:id/cancel' do
    it 'shows the confirmation page for the current learner\'s upcoming booking' do
      session = create(:tutor_session, start_at: 2.days.from_now)
      booking = create(:session_attendee, tutor_session: session, learner: learner)

      log_in_as(learner)
      get cancel_learner_session_path(booking)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Cancel Session')
    end

    it 'does not allow cancelling another learner\'s booking' do
      session = create(:tutor_session, start_at: 2.days.from_now)
      booking = create(:session_attendee, tutor_session: session)

      log_in_as(learner)
      get cancel_learner_session_path(booking)

      expect(response).to redirect_to(learner_sessions_path)
      follow_redirect!
      expect(response.body).to include('You are not authorized to cancel that session')
    end
  end

  describe 'PATCH /learner_sessions/:id/confirm_cancel' do
    it 'cancels the booking when confirmed' do
      session = create(:tutor_session, start_at: 2.days.from_now)
      booking = create(:session_attendee, tutor_session: session, learner: learner)

      log_in_as(learner)
      patch confirm_cancel_learner_session_path(booking), params: { decision: 'yes' }

      expect(booking.reload.cancelled).to be(true)
      expect(response).to redirect_to(learner_sessions_path)
    end

    it "handles failure to cancel gracefully (Sad Path)" do
      session = create(:tutor_session, start_at: 2.days.from_now)
      booking = create(:session_attendee, tutor_session: session, learner: learner)

      log_in_as(learner)
      
      allow_any_instance_of(SessionAttendee).to receive(:update).and_return(false)

      patch confirm_cancel_learner_session_path(booking), params: { decision: 'yes' }

      expect(response).to have_http_status(:unprocessable_content)
      expect(flash[:alert]).to include("Could not cancel session")
    end
  end
end