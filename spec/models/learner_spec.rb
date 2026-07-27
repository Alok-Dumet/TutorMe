require "rails_helper"

RSpec.describe Learner, type: :model do
  describe "validations" do
    it "is invalid without email" do
      learner = build(:learner, email: nil)
      expect(learner).not_to be_valid
      expect(learner.errors[:email]).to include("can't be blank")
    end

    it "is invalid without password" do
      learner = Learner.new(email: "a@b.com")
      expect(learner).not_to be_valid
      expect(learner.errors[:password]).to include("can't be blank")
    end

    it "requires email to be unique case-insensitively" do
      create(:learner, email: "user@site.com")
      dup = build(:learner, email: "USER@site.com")
      expect(dup).not_to be_valid
      expect(dup.errors[:email]).to include("has already been taken")
    end
  end
end