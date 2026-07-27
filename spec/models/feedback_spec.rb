require 'rails_helper'

RSpec.describe Feedback, type: :model do
  # Use FactoryBot's build_stubbed or create to simplify setup
  let(:feedback) { build(:feedback) }

  describe 'validations' do
    it 'is invalid without a rating' do
      feedback.rating = nil
      expect(feedback).not_to be_valid
      expect(feedback.errors[:rating]).to include("can't be blank")
    end

    it 'is invalid without a comment' do
      feedback.comment = nil
      expect(feedback).not_to be_valid
      expect(feedback.errors[:comment]).to include("can't be blank")
    end

    it 'is invalid with rating less than 1' do
      feedback.rating = 0
      expect(feedback).not_to be_valid
      expect(feedback.errors[:rating]).to be_present
    end

    it 'is invalid with rating greater than 5' do
      feedback.rating = 6
      expect(feedback).not_to be_valid
      expect(feedback.errors[:rating]).to be_present
    end

    it 'is invalid with non-integer rating' do
      feedback.rating = 4.5
      expect(feedback).not_to be_valid
      expect(feedback.errors[:rating]).to be_present
    end

    it 'is valid with rating between 1 and 5' do
      feedback.rating = 5
      expect(feedback).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to tutor_session' do
      expect(feedback.tutor_session).to be_present
    end

    it 'belongs to learner' do
      expect(feedback.learner).to be_present
    end

    it 'belongs to tutor' do
      expect(feedback.tutor).to be_present
    end
  end
end