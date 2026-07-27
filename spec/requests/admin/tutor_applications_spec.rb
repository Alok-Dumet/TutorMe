require 'rails_helper'

RSpec.describe "Admin::TutorApplications", type: :request do
  let!(:admin) { create(:admin) }
  let!(:learner) { create(:learner) }
  let!(:application) { create(:tutor_application, learner: learner, status: "pending") }

  describe "GET /admin/tutor_applications/pending" do
    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_admin)
        .and_return(admin)
    end

    it "returns a successful response" do
      get "/admin/tutor_applications/pending"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /admin/tutor_applications/:id/approve" do
    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_admin)
        .and_return(admin)
    end

    context "when valid parameters are passed" do
      it "approves the application and creates a Tutor record succesfully" do
        expect { post "/admin/tutor_applications/#{application.id}/approve" }.to change { Tutor.count }.by(1)

        application.reload
        expect(application.status).to eq("approved")
        expect(response).to have_http_status(:success).or have_http_status(:redirect)
        follow_redirect! if response.redirect?
        expect(response.body).to include("Application approved successfully")
      end
    end

    context "when invalid parameters are passed" do
      it "does not create a Tutor and shows an alert" do
        fake_id = application.id + 9999

        expect { post "/admin/tutor_applications/#{fake_id}/approve" }.not_to change { Tutor.count }

        application.reload
        expect(application.status).to eq("pending")

        expect(response).to have_http_status(:success).or have_http_status(:redirect)
        follow_redirect! if response.redirect?
        expect(response.body).to include("Invalid Learner was passed")
      end
    end

    context "when the learner is already a tutor" do
      before { create(:tutor, learner: learner) }

      it "does not create a Tutor and shows an alert" do
        expect { post "/admin/tutor_applications/#{application.id}/approve" }.not_to change { Tutor.count }

        application.reload
        expect(application.status).to eq("pending")

        expect(response).to have_http_status(:success).or have_http_status(:redirect)
        follow_redirect! if response.redirect?
        expect(response.body).to include("Learner is already Tutor")
      end
    end
  end

  describe "POST /admin/tutor_applications/:id/reject" do
    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_admin)
        .and_return(admin)
    end

    context "when valid parameters are passed" do
      it "deletes the tutor application without creating a Tutor" do
        expect { post "/admin/tutor_applications/#{application.id}/reject" }.to change { TutorApplication.count }.by(-1)
        
        expect(Tutor.count).to eq(0)
        expect(TutorApplication.exists?(application.id)).to be_falsey

        expect(response).to have_http_status(:success).or have_http_status(:redirect)
        follow_redirect! if response.redirect?
        expect(response.body).to include("Application rejected")
      end
    end

    context "when invalid parameters are passed" do
      it "does not delete any application and shows an alert" do
        fake_id = application.id + 9999

        expect { post "/admin/tutor_applications/#{fake_id}/reject" }.not_to change { TutorApplication.count }
        
        expect(response).to have_http_status(:success).or have_http_status(:redirect)
        follow_redirect! if response.redirect?
        expect(response.body).to include("Invalid Learner was passed")
      end
    end

    context "when the learner is already a tutor" do
      before { create(:tutor, learner: learner) }

      it "does not delete any application and shows an alert" do
        expect { post "/admin/tutor_applications/#{application.id}/reject" }.not_to change { TutorApplication.count }
        expect(Tutor.count).to eq(1)

        expect(response).to have_http_status(:success).or have_http_status(:redirect)
        follow_redirect! if response.redirect?
        expect(response.body).to include("Learner is already a Tutor")
      end
    end
  end
end