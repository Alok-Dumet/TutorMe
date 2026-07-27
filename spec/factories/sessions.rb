FactoryBot.define do
  # Tutor Session Factory
  factory :tutor_session do
    association :tutor
    association :subject
    start_at { 1.day.from_now.change(min: 0, sec: 0) }
    end_at { start_at ? start_at + 1.hour : nil }
    capacity { 5 }
    status { "scheduled" }
    meeting_link { "https://zoom.us/test-session" }
  end

  # Session Attendee Factory (Booking)
  factory :session_attendee do
    association :tutor_session
    association :learner
    attended { nil }
    cancelled { false }
    feedback_submitted { false }
  end

  # Feedback Factory
  factory :feedback do
    association :tutor_session
    association :learner
    association :tutor
    rating { 5 }
    comment { "Great session!" }
  end
end