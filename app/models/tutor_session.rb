class TutorSession < ApplicationRecord
  belongs_to :tutor
  belongs_to :subject
  has_many :session_attendees
  has_many :learners, through: :session_attendees
  has_many :feedbacks, dependent: :destroy

  validates :tutor, presence: true
  validates :subject, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :capacity, presence: true, numericality: {greater_than: 0}
  validates :status, presence: true
  validates :meeting_link, presence: true
  validate :end_at_after_start_at
  validate :no_overlapping_sessions

  def end_at_after_start_at
    return if end_at.blank? || start_at.blank?

    if end_at <= start_at
      errors.add(:end_at, "must be after start time")
    end
  end

  def active_attendee_count
    session_attendees.where(cancelled: false).count
  end

  def seats_remaining
    capacity - active_attendee_count
  end

  def full?
    seats_remaining <= 0
  end


  def no_overlapping_sessions
    return if tutor.blank? || end_at.blank? || start_at.blank?
    overlapping = TutorSession
      .where(tutor_id: tutor_id)
      .where.not(id: id)
      .where("start_at< ? AND end_at > ?", end_at, start_at)
    if overlapping.exists?
      errors.add(:start_at, "Session overlaps with existing session")
    end
  end
end