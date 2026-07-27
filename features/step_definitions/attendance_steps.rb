Given('I am a signed-in tutor') do
  email    = 'mia.patel@example.com'
  password = 'password123'

  learner = Learner.find_or_create_by!(email: email) do |l|
    l.password   = password
    l.first_name = 'Mia'
    l.last_name  = 'Patel'
  end

  tutor = Tutor.find_or_create_by!(learner: learner) do |t|
    t.bio = nil
  end

  visit new_login_path
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'

  @current_learner = learner
  @current_tutor   = tutor
end

Given('I am on the "Session Details" page for the session at {string}') do |start_time|
  start_at = Time.iso8601(start_time)
  session = TutorSession.find_by!(start_at: start_at)

  learner = Learner.find_by!(first_name: 'Jane', last_name: 'Doe')
  SessionAttendee.find_or_create_by!(
    tutor_session: session,
    learner: learner
  ) do |sa|
    sa.attended = nil
    sa.feedback_submitted = false
    sa.cancelled = false
  end

  visit session_path(session)
end

Given('the learner is marked as {string}') do |attendance|
  # assumes present/absent are radio buttons
  choose(attendance)
  click_button 'Save'
end

Given('the learner\'s attendance is not marked') do
  expect(page).to have_field('Present', checked: false)
  expect(page).to have_field('Absent', checked: false) 
end

Given('the session has not yet occurred') do
  @current_session.update!(
    start_at: 1.year.from_now,
    end_at: 1.year.from_now + 1.hour
  )
  visit session_path(@current_session)
end

When('I mark the learner as {string}') do |attendance|
  choose(attendance)
end

When('I save the attendance') do
  click_button 'Save'
end

Then('the learner\'s attendance for the session should be set to {string}') do |bool|
  attended = (bool == 'true')
  learner = Learner.find_by!(first_name: 'Jane', last_name: 'Doe')
  current_attendee = SessionAttendee.find_by!(tutor_session: @current_session, learner: learner)
  expect(current_attendee.attended).to eq(attended)
end

Then('I should not see the {string} option') do |radio|
  expect(page).not_to have_field(radio)
end