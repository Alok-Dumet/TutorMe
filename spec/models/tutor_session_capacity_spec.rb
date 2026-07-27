require 'rails_helper'

RSpec.describe TutorSession, type: :model do
  describe "seat availability helpers" do
    let(:session) { create(:tutor_session, capacity: 3) }

    it "counts only non-cancelled attendees" do
      create(:session_attendee, tutor_session: session)
      create(:session_attendee, tutor_session: session)
      create(:session_attendee, tutor_session: session, cancelled: true)

      expect(session.active_attendee_count).to eq(2)
    end

    it "computes seats_remaining correctly" do
      create_list(:session_attendee, 2, tutor_session: session)

      expect(session.seats_remaining).to eq(1)
      expect(session.full?).to eq(false)
    end

    it "detects when a session is full" do
      session.update!(capacity: 2)
      create_list(:session_attendee, 2, tutor_session: session)

      expect(session.active_attendee_count).to eq(2)
      expect(session.seats_remaining).to eq(0)
      expect(session.full?).to eq(true)
    end
  end
end