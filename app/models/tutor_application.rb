class TutorApplication < ApplicationRecord
  validates :reason, presence: true

  validates :status, presence: true, inclusion: { in: [ "pending", "approved" ] }

  belongs_to :learner
end
