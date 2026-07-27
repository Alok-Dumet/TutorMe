require "rails_helper"

RSpec.describe "Home", type: :request do
  let!(:learner) { create(:learner) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_learner).and_return(learner)
  end

  describe "GET / (Home#index)" do
    context "when learner has no existing tutor application" do
      it "renders the page and indicates no application exists" do
        get "/"
        expect(response).to have_http_status(:ok)
        expect(assigns(:tutor_application_status)).to eq(:none)
      end
    end

    context "when learner has a pending tutor application" do
      before { create(:tutor_application, learner: learner, status: "pending") }
      it "renders the page and indicates pending status" do
        get "/"
        expect(response).to have_http_status(:ok)
        expect(assigns(:tutor_application_status)).to eq(:pending)
      end
    end

    context "when learner has an approved tutor application" do
      before { create(:tutor_application, learner: learner, status: "approved") }
      it "renders the page and indicates approved status" do
        get "/"
        expect(response).to have_http_status(:ok)
        expect(assigns(:tutor_application_status)).to be_nil
      end
    end
  end
end