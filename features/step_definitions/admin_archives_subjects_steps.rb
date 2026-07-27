# AUTH / LOGIN

Given('I am logged in as an admin') do
  email    = 'admin@example.com'
  password = 'password123'

  Admin.find_or_create_by!(email: email) do |admin|
    admin.password   = password
    admin.first_name = 'Admin'
    admin.last_name  = 'User'
  end

  visit new_login_path
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'

  expect(page).to have_current_path(home_path)
end

Given('I am logged in as a learner') do
  email    = 'learner@example.com'
  password = 'password123'

  @current_learner = Learner.find_or_create_by!(email: email) do |l|
    l.password   = password
    l.first_name = 'Example'
    l.last_name  = 'Learner'
  end

  visit new_login_path
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'

  expect(page).to have_current_path(home_path)
end

# SUBJECTS MANAGEMENT

When('I go to the subjects management page') do
  visit subjects_path
end

When('I click "Delete" for the subject {string}') do |subject_name|
  # Find the table row for the subject and click its "Delete" link
  within(:xpath, "//tr[td[contains(normalize-space(.), '#{subject_name}')]]") do
    click_button'Delete'
  end
end

Then('I should not see {string} on the subjects page') do |subject_name|
  expect(page).not_to have_content(subject_name)
end

Given('the subject {string} has been archived') do |name|
  subject = Subject.find_by!(name: name)
  subject.update!(archived: true)
end


When('I go to create a new tutor session') do
  visit new_session_path
end

Then('I should not see {string} in the subject dropdown') do |subject_name|
  expect(page).not_to have_select('Subject', with_options: [subject_name])
end


Given('a tutor session exists with subject {string}') do |subject_name| 
  @current_learner ||= Learner.find_or_create_by!(email: 'learner@example.com') do |l|
    l.password   = 'password123'
    l.first_name = 'Example'
    l.last_name  = 'Learner'
  end

  subject = Subject.find_or_create_by!(name: subject_name) do |s|
    s.code = subject_name.parameterize.upcase.first(6)
  end

  tutor_email = 'archive-tutor@example.com'
  tutor_learner = Learner.find_or_create_by!(email: tutor_email) do |l|
    l.password   = 'password123'
    l.first_name = 'Archive'
    l.last_name  = 'Tutor'
  end

  tutor = Tutor.find_or_create_by!(learner: tutor_learner) do |t|
    t.bio = 'Archive test tutor'
  end


  start_time = 1.day.ago.change(sec: 0)   # in the past
  end_time   = start_time + 1.hour

  @tutor_session = TutorSession.create!(
    tutor:        tutor,
    subject:      subject,
    start_at:     start_time,
    end_at:       end_time,
    capacity:     3,
    status:       'scheduled',
    meeting_link: 'https://example.org/meet/archive-test'
  )

  SessionAttendee.find_or_create_by!(
    tutor_session: @tutor_session,
    learner:       @current_learner
  )
end

When('I visit the details page for that tutor session') do
  visit session_path(@tutor_session)
end

Then('I should see {string} as the subject for the session') do |subject_name|
  expect(page).to have_content(subject_name)
end