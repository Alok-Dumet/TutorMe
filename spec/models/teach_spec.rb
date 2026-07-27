require 'rails_helper'

RSpec.describe Teach, type: :model do
  context 'validations' do
    it 'is invalid without a tutor' do
      teach = build(:teach, tutor: nil)
      expect(teach).not_to be_valid
      expect(teach.errors[:tutor]).to include("must exist")
    end

    it 'is invalid without a subject' do
      teach = build(:teach, subject: nil)
      expect(teach).not_to be_valid
      expect(teach.errors[:subject]).to include("must exist")
    end

    it 'requires tutor and subject to be a unique pair' do
      tutor = create(:tutor)
      subject = create(:subject)
      
      create(:teach, tutor: tutor, subject: subject)
      
      dup_teach = build(:teach, tutor: tutor, subject: subject)
      expect(dup_teach).not_to be_valid
      expect(dup_teach.errors[:tutor]).to include('has already been taken')
    end

    context 'associations' do
      it 'belongs to a tutor and a subject' do
        teach = create(:teach)
        expect(teach.tutor).to be_present
        expect(teach.subject).to be_present
      end
    end
  end
end