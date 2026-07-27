class Subject < ApplicationRecord
  has_many :teaches, dependent: :destroy
  has_many :tutors, through: :teaches

  validates :name, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }

  scope :active,   -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }

end