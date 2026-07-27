FactoryBot.define do
  # Admin Factory
  factory :admin do
    sequence(:email) { |n| "admin#{n}@example.com" }
    password { "password123" }
    first_name { "Admin" }
    last_name { "User" }
  end

  # Learner Factory
  factory :learner do
    sequence(:email) { |n| "learner#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    first_name { "Test" }
    last_name { "Learner" }
  end
end