require 'time'
require 'securerandom'

Given('I am a signed-in learner') do
  email    = "mia-patel@example.com"
  password = "password123"

  @current_learner ||= Learner.find_or_create_by!(email: email) do |l|
    l.password   = password
    l.first_name = "Mia"
    l.last_name  = "Patel"
  end

  visit new_login_path
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'
end

Given('I am on the "Find a Session" page') do
  visit search_sessions_path
  expect(page).to have_content("Find a Session")
end

Given('the subject {string} exists') do |subject_name|
  Subject.find_or_create_by!(name: subject_name) do |s|
    s.code = subject_name.parameterize.upcase.first(6)
    s.description = "#{subject_name} subject"
  end
end

Given('the following tutors and sessions exist:') do |table|
  table.hashes.each do |row|
    subj = Subject.find_by!(name: row['subject'])

    names = row['tutor_name'].to_s.strip.split
    first = names[0..-2].join(' ').presence || names.first
    last  = names.last
    tutor_learner = Learner.find_or_create_by!(email: "#{first.downcase.gsub(/\s+/, '_')}.#{last.downcase}@example.com") do |l|
      l.password   = "password123"
      l.first_name = first
      l.last_name  = last
    end
    tutor = Tutor.find_or_create_by!(learner: tutor_learner)

    Teach.find_or_create_by!(tutor: tutor, subject: subj)

    session = TutorSession.find_or_create_by!(
      tutor: tutor,
      subject: subj,
      start_at: Time.iso8601(row['session_start']),
      end_at:   Time.iso8601(row['session_end'])
    ) do |s|
      s.capacity     = row['capacity'].to_i
      s.status       = 'scheduled'
      s.meeting_link = "https://example.org/meet/#{SecureRandom.hex(3)}"
    end

    if row['capacity'].to_i == 1
      dummy_learner = Learner.find_or_create_by!(email: "dummy@example.com") do |l|
        l.password = "password123"
        l.first_name = "Dummy"
        l.last_name = "User"
      end

      SessionAttendee.find_or_create_by!(
        tutor_session: session,
        learner: dummy_learner
      )
    end
  end
end

Given('I am learner {string} with no upcoming sessions') do |learner_name|
  first, last = (learner_name.split(' ', 2) + [ nil ]).take(2)
  email = "#{learner_name.parameterize}@example.com"
  @current_learner = Learner.find_or_create_by!(email: email) do |l|
    l.password   = "password123"
    l.first_name = first || learner_name
    l.last_name  = last
  end
end

Given('I am learner {string} who has an existing session with tutor {string} from {string} to {string} in {string}') do |learner_name, tutor_name, start_iso, end_iso, subject_name|
  # Ensure learner
  first, last = (learner_name.split(' ', 2) + [ nil ]).take(2)
  email = "#{learner_name.parameterize}@example.com"
  @current_learner = Learner.find_or_create_by!(email: email) do |l|
    l.password   = "password123"
    l.first_name = first || learner_name
    l.last_name  = last
  end

  # Ensure subject
  subj = Subject.find_or_create_by!(name: subject_name) do |s|
    s.code = subject_name.parameterize.upcase.first(6)
    s.description = "#{subject_name} subject"
  end

  # Ensure tutor
  tnames = tutor_name.split
  tfirst = tnames[0..-2].join(' ').presence || tnames.first
  tlast  = tnames.last
  tutor_learner = Learner.find_or_create_by!(email: "#{tfirst.downcase.gsub(/\s+/, '_')}.#{tlast.downcase}@example.com") do |l|
    l.password   = "password123"
    l.first_name = tfirst
    l.last_name  = tlast
  end
  tutor = Tutor.find_or_create_by!(learner: tutor_learner)
  Teach.find_or_create_by!(tutor: tutor, subject: subj)

  # Ensure the existing session
  start_t = Time.iso8601(start_iso)
  end_t   = Time.iso8601(end_iso)
  ses = TutorSession.find_or_create_by!(tutor: tutor, subject: subj, start_at: start_t, end_at: end_t) do |s|
    s.capacity     = 3
    s.status       = 'scheduled'
    s.meeting_link = "https://example.org/meet/#{SecureRandom.hex(3)}"
  end

  # Ensure the attendee row
  SessionAttendee.find_or_create_by!(tutor_session: ses, learner: @current_learner) do |sa|
    sa.attended            = false
    sa.feedback_submitted  = false
    sa.cancelled           = false
  end
end

When('I choose subject {string}') do |subject|
  fill_in 'subject', with: subject
end

When('I enter start {string} and end {string}') do |start_at, end_at|
  fill_in 'start_at', with: start_at
  fill_in 'end_at',   with: end_at
end

When('I run the search') do
  click_button 'Search'
  expect(page).to have_content("Search Results")
end

When('I select the session for tutor {string} from {string} to {string}') do |tutor_name, start_iso, end_iso|
  session_card = page.find('.card', text: tutor_name)
  
  within(session_card) do
    click_button 'Select'
  end
  
  expect(page).to have_content("Booking")
end

When('I confirm the booking') do
  click_button('Confirm Booking') if page.has_button?('Confirm Booking')
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

# new step for self-booking
Given('I am also a tutor and have a session') do
  subj = Subject.find_or_create_by!(name: 'test', code: 'TEST101', description: 'subject to test self booking')
  tutor = Tutor.find_or_create_by!(learner: @current_learner)
  session = TutorSession.find_or_create_by!(
    tutor: tutor,
    subject: subj,
    start_at: Time.iso8601('2026-03-10T11:00:00Z'),
    end_at:   Time.iso8601('2026-03-10T12:00:00Z'),
    capacity: 2,
    status: 'scheduled',
    meeting_link: "https://example.org/meet/#{SecureRandom.hex(3)}"
  )
end

Given('I find and select my own session') do
  start_at = Time.iso8601('2026-03-10T11:00:00Z')
  end_at = Time.iso8601('2026-03-10T12:00:00Z')
  fill_in 'subject', with: 'test'
  fill_in 'start_at', with: start_at
  fill_in 'end_at',   with: end_at
  click_button 'Search'
  
  session_card = page.find('.card', text: 'Mia Patel')
  within(session_card) do
    click_button 'Select'
  end
end