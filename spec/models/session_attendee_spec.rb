require 'rails_helper'

RSpec.describe SessionAttendee, type: :model do
  # Utilizing factories to create relationships
  let(:learner1) { create(:learner) }
  let(:learner2) { create(:learner) }
  let(:learner3) { create(:learner) }
  
  let(:tutor) { create(:tutor) }
  let(:subject) { create(:subject) }
  
  let(:session1) do
    create(:tutor_session, 
      tutor: tutor, 
      subject: subject, 
      start_at: Time.zone.parse('2026-03-10T10:00:00Z'),
      end_at: Time.zone.parse('2026-03-10T11:00:00Z'),
      capacity: 2
    )
  end
  
  let(:conflicting_session) do
    create(:tutor_session,
      tutor: create(:tutor),
      subject: subject,
      start_at: Time.zone.parse('2026-03-10T10:30:00Z'),
      end_at: Time.zone.parse('2026-03-10T11:30:00Z'),
      capacity: 2
    )
  end

  context 'validations' do
    it 'is invalid without tutor_session' do
      attendee = build(:session_attendee, tutor_session: nil)
      expect(attendee).not_to be_valid
      expect(attendee.errors[:tutor_session]).to include("can't be blank")
    end

    it 'is invalid without learner' do
      attendee = build(:session_attendee, learner: nil)
      expect(attendee).not_to be_valid
      expect(attendee.errors[:learner]).to include("can't be blank")
    end

    it 'is invalid when session is at full capacity' do
      create(:session_attendee, tutor_session: session1, learner: learner1)
      create(:session_attendee, tutor_session: session1, learner: learner2)
      
      attendee3 = build(:session_attendee, tutor_session: session1, learner: learner3)
      expect(attendee3).not_to be_valid
      expect(attendee3.errors[:base]).to include("This session is full")
    end

    it 'is invalid when learner is already booked for the same session (double booking)' do
      create(:session_attendee, tutor_session: session1, learner: learner1)
      
      dupe = build(:session_attendee, tutor_session: session1, learner: learner1)
      expect(dupe).not_to be_valid
      expect(dupe.errors[:learner_id]).to include("is already booked for this session")
    end

    it 'is invalid when learner has a conflicting session (overlapping times)' do
      create(:session_attendee, tutor_session: session1, learner: learner1)

      conflicting_attendee = build(:session_attendee, tutor_session: conflicting_session, learner: learner1)
      expect(conflicting_attendee).not_to be_valid
      expect(conflicting_attendee.errors[:base]).to include("This session conflicts with another session")
    end
  end

  context 'associations' do
    it 'belongs to a tutor_session and a learner' do
        attendee = create(:session_attendee, tutor_session: session1, learner: learner1)
        expect(attendee.tutor_session).to eq(session1)
        expect(attendee.learner).to eq(learner1)
    end
  end
end