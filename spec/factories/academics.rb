FactoryBot.define do
  # Subject Factory
  factory :subject do
    sequence(:name) { |n| "Subject #{n}" }
    sequence(:code) { |n| "SUBJ#{n}" }
    description { "This is a test subject description." }
    archived { false }
  end

  # Tutor Factory
  factory :tutor do
    association :learner
    bio { "I am an experienced tutor." }
  end

  # Teach Factory (Join table for Tutor and Subject)
  factory :teach do
    association :tutor
    association :subject
  end

  # Tutor Application Factory
  factory :tutor_application do
    association :learner
    reason { "I want to help students learn." }
    status { "pending" }
  end
end