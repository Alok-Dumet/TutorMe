require 'rails_helper'
require 'cgi'

RSpec.describe "Tutors", type: :request do
  describe "GET /tutors" do
    it "lists all tutors when no filter is applied" do
      create(:tutor, bio: "Bio 1")
      create(:tutor, bio: "Bio 2")
      get tutors_path
      expect(response).to have_http_status(:ok)
    end

    it "filters tutors by subject name" do
      calc = create(:subject, name: "Calculus")
      stats = create(:subject, name: "Statistics")

      t1 = create(:tutor)
      create(:teach, tutor: t1, subject: calc)
      
      t2 = create(:tutor)
      create(:teach, tutor: t2, subject: stats)

      get tutors_path, params: { subject: "Calculus" }

      expect(assigns(:tutors)).to include(t1)
      expect(assigns(:tutors)).not_to include(t2)
    end
  end

  describe "PATCH /tutors/:id" do
    let(:tutor) { create(:tutor) }

    before do
      allow_any_instance_of(ApplicationController)
        .to receive(:current_learner).and_return(tutor.learner)
    end

    it "successfully updates the bio" do
      patch tutor_path(tutor), params: { tutor: { bio: "New Bio" } }
      expect(tutor.reload.bio).to eq("New Bio")
      expect(response).to redirect_to(edit_tutor_path(tutor))
    end

    it "fails validation with too long bio (Sad Path)" do
      long_bio = "a" * 501
      patch tutor_path(tutor), params: { tutor: { bio: long_bio } }
      
      expect(response).to have_http_status(:unprocessable_content)
      expect(CGI.unescapeHTML(response.body)).to include("Character limit exceeded")
    end

    it "does not allow editing another tutor" do
      other = create(:tutor)
      patch tutor_path(other), params: { tutor: { bio: "Hacked" } }
      expect(response).to redirect_to(home_path)
      expect(flash[:alert]).to include("not authorized")
    end
  end
end