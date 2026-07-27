class SessionAttendee < ApplicationRecord
  belongs_to :tutor_session, class_name: 'TutorSession'
  belongs_to :learner

  validates :tutor_session, presence: true
  validates :learner, presence: true

  # A learner can only have one *active* (not cancelled) booking per session
  validates :learner_id, uniqueness: {
    scope: :tutor_session_id,
    conditions: -> { where(cancelled: false) },
    message: 'is already booked for this session'
  }

  validate :session_not_full
  validate :time_conflicts

  # Scopes to retrieve bookings for a given learner
  scope :for_learner, ->(learner) { where(learner:) }

  scope :upcoming_for, ->(learner) {
    for_learner(learner)
      .joins(:tutor_session)
      .where('tutor_sessions.start_at >= ?', Time.current)
      .where('session_attendees.cancelled = ?', false)
      .order('tutor_sessions.start_at ASC')
}

  scope :past_for, ->(learner) {
    for_learner(learner)
      .joins(:tutor_session)
      .where(cancelled: false)
      .where('tutor_sessions.start_at < ?', Time.current)
      .order('tutor_sessions.start_at DESC')
  }

  def session_not_full
    return unless tutor_session

    # Only count non-cancelled attendees when enforcing capacity
    attendee_count = SessionAttendee.where(
      tutor_session_id: tutor_session.id,
      cancelled: false
    ).count

    if new_record? && attendee_count >= tutor_session.capacity
      errors.add(:base, 'This session is full')
    end
  end

  def time_conflicts
    return unless learner && tutor_session

    # Only consider other non-cancelled bookings when checking for overlaps
    learner_sessions = SessionAttendee
                         .where(learner_id: learner.id, cancelled: false)
                         .where.not(tutor_session_id: tutor_session.id)
                         .includes(:tutor_session)

    learner_sessions.each do |attendee|
      existing_session = attendee.tutor_session

      if tutor_session.start_at < existing_session.end_at &&
         tutor_session.end_at > existing_session.start_at
        errors.add(:base, 'This session conflicts with another session')
        break
      end
    end
  end
end