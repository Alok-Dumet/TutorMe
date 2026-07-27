require 'rails_helper'

RSpec.describe Subject, type: :model do
  context 'validations' do
    it 'is invalid without a name' do
      s = build(:subject, name: nil)
      expect(s).not_to be_valid
      expect(s.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without a code' do
      s = build(:subject, code: nil)
      expect(s).not_to be_valid
      expect(s.errors[:code]).to include("can't be blank")
    end

    it 'requires code to be unique (case-insensitive)' do
      create(:subject, code: 'MATH101')
      dup = build(:subject, code: 'math101')
      expect(dup).not_to be_valid
      expect(dup.errors[:code]).to include('has already been taken')
    end

    context 'associations' do 
      it 'can have many teaches' do
        s = create(:subject)
        create(:teach, subject: s)
        create(:teach, subject: s)
        expect(s.teaches.count).to eq(2)
      end
  
      it 'can have many tutors through teaches' do
        s = create(:subject)
        t1 = create(:teach, subject: s).tutor
        t2 = create(:teach, subject: s).tutor
        
        expect(s.tutors).to include(t1, t2)
      end
    end
  end
end