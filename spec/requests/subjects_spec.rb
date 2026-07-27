require 'rails_helper'
require 'cgi'

RSpec.describe "Subjects", type: :request do
  let(:admin) { create(:admin) }

  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:current_admin).and_return(admin)
  end

  describe "GET /subjects/new" do
    it "renders the new template" do
      get new_subject_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New Subject")
    end
  end

  describe "POST /subjects" do
    it "creates a subject and redirects on success" do
      expect {
        post subjects_path, params: { subject: attributes_for(:subject) }
      }.to change(Subject, :count).by(1)
      
      expect(response).to redirect_to(new_subject_path)
      expect(flash[:notice]).to include("Subject created")
    end

    it "re-renders with errors on failure" do
      post subjects_path, params: { subject: { name: "Physics", code: "" } }
      expect(response).to have_http_status(:unprocessable_content)
      expect(CGI.unescapeHTML(response.body)).to include("Code can't be blank")
    end
  end

  describe "DELETE /subjects/:id" do
    it "marks the subject as archived instead of deleting it" do
      subject = create(:subject)
      delete subject_path(subject)
      expect(subject.reload.archived).to eq(true)
    end

    it "alerts if archiving fails (Sad Path)" do
      subject = create(:subject)
      
      allow_any_instance_of(Subject).to receive(:update).and_return(false)

      delete subject_path(subject)
      expect(flash[:alert]).to include("Could not archive subject")
      expect(response).to redirect_to(subjects_path)
    end
  end
end