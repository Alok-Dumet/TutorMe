require "rails_helper"

RSpec.describe "TutorApplications", type: :request do
  let!(:learner) { create(:learner) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_learner).and_return(learner)
  end

  describe "GET /tutor_applications/new" do
    it "renders the application page" do
      get "/tutor_applications/new"
      expect(response).to have_http_status(:ok)
    end

    it "redirects if application is pending" do
      create(:tutor_application, learner: learner, status: "pending")
      get "/tutor_applications/new"
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST /tutor_applications" do
    it "creates application and redirects" do
      expect {
        post "/tutor_applications", params: { tutor_application: { reason: "Teach" } }
      }.to change(TutorApplication, :count).by(1)
      expect(response).to redirect_to(root_path)
    end
  end
end