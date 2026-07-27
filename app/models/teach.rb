class Teach < ApplicationRecord
    belongs_to :tutor
    belongs_to :subject
    validates :tutor, uniqueness: { scope: :subject }
end