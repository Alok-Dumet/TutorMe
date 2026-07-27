require 'rails_helper'
require 'cgi'

RSpec.describe "Feedbacks", type: :request do
  let(:learner) { create(:learner) }
  let(:tutor) { create(:tutor) }
  let(:session) { create(:tutor_session, tutor: tutor, start_at: 2.days.ago) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_learner).and_return(learner)
  end

  describe "GET /sessions/:session_id/feedbacks/new" do
    it "renders the feedback form if learner attended" do
      create(:session_attendee, tutor_session: session, learner: learner, attended: true)
      
      get new_session_feedback_path(session)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Submit Feedback")
    end

    it "redirects if learner was not marked present (Sad Path)" do
      create(:session_attendee, tutor_session: session, learner: learner, attended: false)

      get new_session_feedback_path(session)
      expect(response).to redirect_to(session_path(session))
      expect(flash[:alert]).to include("You were not marked present")
    end

    it "redirects if learner has already submitted feedback (Edge Case)" do
      create(:session_attendee, tutor_session: session, learner: learner, attended: true)
      create(:feedback, tutor_session: session, learner: learner, tutor: tutor)

      get new_session_feedback_path(session)
      expect(response).to redirect_to(session_path(session))
      expect(flash[:alert]).to include("You have already submitted feedback")
    end
  end

  describe "POST /sessions/:session_id/feedbacks" do
    before do
      create(:session_attendee, tutor_session: session, learner: learner, attended: true)
    end

    it "creates feedback with valid params" do
      expect {
        post session_feedbacks_path(session), params: { feedback: { rating: 5, comment: "Great!" } }
      }.to change(Feedback, :count).by(1)

      expect(response).to redirect_to(learner_sessions_path)
      expect(flash[:notice]).to include("Thank you")
    end

    it "fails with invalid params (Sad Path)" do
      post session_feedbacks_path(session), params: { feedback: { rating: nil, comment: "" } }
      
      expect(response).to have_http_status(:unprocessable_content)
      expect(CGI.unescapeHTML(response.body)).to include("Rating can't be blank")
    end
  end
end