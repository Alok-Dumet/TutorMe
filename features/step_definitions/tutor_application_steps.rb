Given('I am a Tutor') do
  @current_tutor ||= Tutor.find_or_create_by!(learner_id: @current_learner.id) do |t|
    t.bio = nil
  end
end

When('I visit the Home page') do
  visit root_path
end

Then('I should see the {string} link') do |string|
  expect(page).to have_link(string)
end

When('I click the {string} button') do |string|
    click_button(string)
end

When('I click the {string} link') do |string|
  dashboard_link = first('.card-body a', text: string)

  if dashboard_link
    dashboard_link.click
  else
    click_link(string)
  end
end

Then('I should see the tutor application page') do
    expect(page).to have_content('Apply To Be A Tutor')
end

Given('I visit the tutor application page') do
    visit new_tutor_application_path
end

Given('I enter reason {string}') do |string|
  fill_in 'Why do you want to become a tutor?', with: string
end

Then('I should see a message that my application was submitted') do
  expect(page).to have_content('Application Sent!')
end

Then('I should not see the {string} button') do |string|
  expect(page).not_to have_button(string)
end

Then('I should not see the {string} link') do |string|
  expect(page).not_to have_link(string)
end

Then('I should not see the {string} message') do |string|
  expect(page).not_to have_content(string)
end

Given('I have a pending application') do
    learner = Learner.find_by(email:  @current_learner.email)
    TutorApplication.find_or_create_by!(learner: learner, reason: 'Testing reason', status: "pending")
end

Given('an admin has approved my application') do
  @current_learner ||= Learner.find_or_create_by!(email: "mia.patel@example.com") do |l|
    l.password   = "password123"
    l.first_name = "Mia"
    l.last_name  = "Patel"
  end

  @current_tutor ||= Tutor.find_or_create_by!(learner_id: @current_learner.id) do |t|
    t.bio = nil
  end

  TutorApplication.find_by(learner: @current_learner)&.destroy
end

When('I sign-in as a learner') do
  visit login_path
  fill_in 'Email', with: @current_learner.email
  fill_in 'Password', with: @current_learner.password
  click_button 'Log in'
end