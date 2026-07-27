class Tutor < ApplicationRecord
    belongs_to :learner
    has_many :teaches, dependent: :destroy
    has_many :subjects, through: :teaches
    has_many :feedbacks, dependent: :destroy
    
    validates :learner, uniqueness: true
    validates :bio, length: { maximum: 500, message: "Character limit exceeded (500)" }

    def average_rating
      return 0.0 if feedbacks.empty?
      feedbacks.average(:rating).to_f
    end

    def reviews_count
      feedbacks.count
    end
end