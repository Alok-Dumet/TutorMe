class Learner < ApplicationRecord
  has_secure_password

  attr_accessor :validate_name_presence

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false }

  validates :first_name, :last_name,
            presence: true,
            if: :validate_name_presence?

  has_many :session_attendees, dependent: :destroy
  has_many :tutor_sessions, through: :session_attendees
  has_many :feedbacks, dependent: :destroy
  has_one :tutor_application

  private
  def validate_name_presence?
    !!validate_name_presence
  end
end