require "rails_helper"
require "cgi"

RSpec.describe "Learners", type: :request do
  describe "GET /learners/new" do
    it "renders the sign-up page" do
      get new_learner_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Sign up")
    end
  end

  describe "POST /learners" do
    let(:valid_attributes) { attributes_for(:learner) }

    it "creates a learner and redirects with notice on success" do
      expect do
        post learners_path, params: { learner: valid_attributes }
      end.to change(Learner, :count).by(1)

      expect(response).to redirect_to(new_login_path)
      follow_redirect!
      expect(response.body).to include("Account Created!")
    end

    it "re-renders with errors when email is missing" do
      invalid_attributes = valid_attributes.merge(email: "")
      post learners_path, params: { learner: invalid_attributes }
      expect(response).to have_http_status(:unprocessable_content)
      # Fix: Unescape HTML to handle "can&#39;t" -> "can't"
      expect(CGI.unescapeHTML(response.body)).to include("Email can't be blank")
    end

    it "re-renders with errors when password is missing" do
      invalid_attributes = valid_attributes.merge(password: "", password_confirmation: "")
      post learners_path, params: { learner: invalid_attributes }
      expect(response).to have_http_status(:unprocessable_content)
      # Fix: Unescape HTML
      expect(CGI.unescapeHTML(response.body)).to include("Password can't be blank")
    end

    it "re-renders with errors when email is taken" do
      create(:learner, email: "dup@site.com")
      invalid_attributes = valid_attributes.merge(email: "DUP@site.com")

      post learners_path, params: { learner: invalid_attributes }
      expect(response).to have_http_status(:unprocessable_content)
      expect(CGI.unescapeHTML(response.body)).to include("Email has already been taken")
    end
  end
end