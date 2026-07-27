Then('I should be on the tutor upcoming sessions page') do
  expect(page).to have_current_path(tutor_sessions_path)
end

Then('I should be on the tutor past sessions page') do
  expect(page).to have_current_path(past_tutor_sessions_path)
end

When('I visit the tutor sessions page directly') do
  visit tutor_sessions_path
end

Given('I am logged out') do
  reset_session!
end