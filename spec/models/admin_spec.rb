require "rails_helper"

RSpec.describe Admin, type: :model do
  describe "validations" do
    it "is invalid without email" do
      admin = build(:admin, email: nil)
      expect(admin).not_to be_valid
      expect(admin.errors[:email]).to include("can't be blank")
    end

    it "is invalid without password" do
      # Directly instantiate because FactoryBot build might set a default password
      admin = Admin.new(email: "admin@site.com")
      expect(admin).not_to be_valid
      expect(admin.errors[:password]).to include("can't be blank")
    end

    it "requires email to be unique case-insensitively" do
      create(:admin, email: "admin@site.com")
      dup = build(:admin, email: "ADMIN@site.com")
      expect(dup).not_to be_valid
      expect(dup.errors[:email]).to include("has already been taken")
    end
  end
end