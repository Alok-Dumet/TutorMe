require 'rails_helper'

RSpec.describe 'TutorSessions', type: :request do
  let(:tutor) { create(:tutor) }

  def log_in_as(tutor)
    post login_path, params: { email: tutor.learner.email, password: tutor.learner.password }
  end

  describe 'GET /tutor_sessions' do
    it 'shows only upcoming sessions for the current tutor' do
      create(:tutor_session, tutor: tutor, start_at: 2.days.from_now, subject: create(:subject, name: 'Bio'))
      create(:tutor_session, tutor: tutor, start_at: 2.days.ago, subject: create(:subject, name: 'Math'))

      log_in_as(tutor)
      get tutor_sessions_path

      expect(response.body).to include('Bio')
      expect(response.body).not_to include('Math')
    end
  end

  describe "PATCH /tutor/sessions/:id" do
    it "updates the meeting link" do
      session = create(:tutor_session, tutor: tutor, start_at: 2.days.from_now)
      log_in_as(tutor)
      
      patch tutor_session_path(session), params: { tutor_session: { meeting_link: 'new-link' } }
      expect(session.reload.meeting_link).to eq('new-link')
    end

    it "fails to update with invalid data (Sad Path)" do
      session = create(:tutor_session, tutor: tutor, start_at: 2.days.from_now)
      log_in_as(tutor)

      patch tutor_session_path(session), params: { tutor_session: { meeting_link: '' } }
      
      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Edit Session") # Renders edit again
    end
    
    it "redirects if attempting to edit past session" do
      session = create(:tutor_session, tutor: tutor, start_at: 2.days.ago)
      log_in_as(tutor)
      get edit_tutor_session_path(session)
      expect(response).to redirect_to(tutor_sessions_path)
      expect(flash[:alert]).to include("You can only edit upcoming sessions")
    end
  end

  describe 'PATCH /tutor_sessions/:id/confirm_cancel' do
    it 'allows the tutor to cancel their own upcoming session' do
      session = create(:tutor_session, tutor: tutor, start_at: 2.days.from_now)
      log_in_as(tutor)
      
      patch confirm_cancel_tutor_session_path(session)
      expect(session.reload.status).to eq('cancelled')
    end

    it "prevents cancelling a past session (Edge Case)" do
      session = create(:tutor_session, tutor: tutor, start_at: 2.days.ago)
      log_in_as(tutor)

      patch confirm_cancel_tutor_session_path(session)
      
      expect(session.reload.status).not_to eq('cancelled')
      expect(flash[:alert]).to include("You can only cancel upcoming sessions")
    end

    it "prevents cancelling another tutor's session (Security)" do
      other_tutor = create(:tutor)
      session = create(:tutor_session, tutor: other_tutor, start_at: 2.days.from_now)
      log_in_as(tutor) # Logged in as 'tutor', trying to cancel 'other_tutor's session

      patch confirm_cancel_tutor_session_path(session)

      expect(session.reload.status).not_to eq('cancelled')
      expect(flash[:alert]).to include("not authorized")
    end
  end
end