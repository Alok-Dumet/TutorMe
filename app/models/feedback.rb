class Feedback < ApplicationRecord
  belongs_to :tutor_session
  belongs_to :learner
  belongs_to :tutor

  validates :rating, presence: true,
                     numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :comment, presence: true

  validate :rating_presence_message

  private

  def rating_presence_message
    errors.add(:base, "Rating can't be blank") if rating.blank?
  end
end
