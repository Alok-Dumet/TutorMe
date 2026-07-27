require 'rails_helper'

RSpec.describe TutorSession, type: :model do
  context 'validations' do
    let(:tutor) { create(:tutor) }
    let(:subject) { create(:subject) }

    it 'is invalid without tutor' do
      s = build(:tutor_session, tutor: nil)
      expect(s).not_to be_valid
      expect(s.errors[:tutor]).to include("can't be blank")
    end

    it 'is invalid without a subject' do
      s = build(:tutor_session, subject: nil)
      expect(s).not_to be_valid
      expect(s.errors[:subject]).to include("can't be blank")
    end

    it 'is invalid without start_at time' do
      s = build(:tutor_session, start_at: nil)
      expect(s).not_to be_valid
      expect(s.errors[:start_at]).to include("can't be blank")
    end

    it 'is invalid without end_at time' do
      s = build(:tutor_session, end_at: nil)
      expect(s).not_to be_valid
      expect(s.errors[:end_at]).to include("can't be blank")
    end

    it 'is invalid without capacity' do
      s = build(:tutor_session, capacity: nil)
      expect(s).not_to be_valid
      expect(s.errors[:capacity]).to include("can't be blank")
    end

    it 'is invalid without status' do
      s = build(:tutor_session, status: nil)
      expect(s).not_to be_valid
      expect(s.errors[:status]).to include("can't be blank")
    end

    it 'is invalid without a meeting_link' do
      s = build(:tutor_session, meeting_link: nil)
      expect(s).not_to be_valid
      expect(s.errors[:meeting_link]).to include("can't be blank")
    end

    it 'is invalid with a negative or 0 capacity' do
      s = build(:tutor_session, capacity: -1)
      expect(s).not_to be_valid
      expect(s.errors[:capacity]).to include("must be greater than 0")
    end

    it 'is invalid with an end_at time before start_at time' do
      s = build(:tutor_session, start_at: 2.hours.from_now, end_at: 1.hour.from_now)
      expect(s).not_to be_valid
      expect(s.errors[:end_at]).to include("must be after start time")
    end

    it 'is invalid if session overlaps with existing session for same tutor' do
      create(:tutor_session, 
        tutor: tutor, 
        start_at: Time.zone.parse('2026-04-11T10:00:00Z'),
        end_at: Time.zone.parse('2026-04-11T11:00:00Z')
      )
      
      s = build(:tutor_session,
        tutor: tutor,
        start_at: Time.zone.parse('2026-04-11T10:30:00Z'),
        end_at: Time.zone.parse('2026-04-11T11:30:00Z')
      )
      expect(s).not_to be_valid
      expect(s.errors[:start_at]).to include("Session overlaps with existing session")
    end
  end
end