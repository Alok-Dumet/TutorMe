require "rails_helper"

RSpec.describe TutorApplication, type: :model do
  context 'validations' do
    it "is invalid without a reason" do
      app = build(:tutor_application, reason: nil)
      expect(app).not_to be_valid
      expect(app.errors[:reason]).to include("can't be blank")
    end

    it "is invalid without a status" do
      app = build(:tutor_application, status: nil)
      expect(app).not_to be_valid
      expect(app.errors[:status]).to include("can't be blank")
    end

    it "is valid when status is pending or approved" do
      expect(build(:tutor_application, status: "pending")).to be_valid
      expect(build(:tutor_application, status: "approved")).to be_valid
    end

    it "is invalid when status is invalid" do
      app = build(:tutor_application, status: "denied")
      expect(app).not_to be_valid
      expect(app.errors[:status]).to include("is not included in the list")
    end

    it "is invalid without a learner" do
      app = build(:tutor_application, learner: nil)
      expect(app).not_to be_valid
      expect(app.errors[:learner]).to include("must exist")
    end
  end
end