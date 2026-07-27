require 'rails_helper'

RSpec.describe Tutor, type: :model do
  context 'validations' do
    it 'is invalid without a learner' do
      t = build(:tutor, learner: nil)
      expect(t).not_to be_valid
      expect(t.errors[:learner]).to include("must exist")
    end

    it 'requires learner to be unique' do
      l = create(:learner)
      create(:tutor, learner: l)
      dup_tutor = build(:tutor, learner: l)
      expect(dup_tutor).not_to be_valid
      expect(dup_tutor.errors[:learner]).to include('has already been taken')
    end


    context 'bio validations' do
      it 'allows bio to be nil' do
        t = build(:tutor, bio: nil)
        expect(t).to be_valid
      end

      it 'allows bio to be empty' do
        t = build(:tutor, bio: '')
        expect(t).to be_valid
      end

      it 'requires bio to be less than 500 characters' do
        t = build(:tutor, bio: 'a' * 501)
        expect(t).not_to be_valid
        expect(t.errors[:bio]).to include("Character limit exceeded (500)")
      end
    end

    context 'associations' do
      it 'can have many teaches' do
        t = create(:tutor)
        create(:teach, tutor: t)
        create(:teach, tutor: t)
        expect(t.teaches.count).to eq(2)
      end
  
      it 'can have many subjects through teaches' do
        t = create(:tutor)
        s1 = create(:teach, tutor: t).subject
        s2 = create(:teach, tutor: t).subject
        expect(t.subjects).to include(s1, s2)
      end
    end

    context 'rating calculations' do
      let(:tutor) { create(:tutor) }
      let(:learner) { create(:learner) }
      let(:session) { create(:tutor_session, tutor: tutor) }

      it 'calculates average rating correctly' do
        create(:feedback, tutor: tutor, tutor_session: session, rating: 5, learner: create(:learner))
        create(:feedback, tutor: tutor, tutor_session: session, rating: 3, learner: create(:learner))
        
        expect(tutor.average_rating).to eq(4.0)
        expect(tutor.reviews_count).to eq(2)
      end

      it 'returns 0 if no feedbacks' do
        expect(tutor.average_rating).to eq(0.0)
        expect(tutor.reviews_count).to eq(0)
      end
    end
  end
end