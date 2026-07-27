require 'time'

# Simple content checks: just delegate to the existing "I should see" step

Then('I should see {string} in the search results') do |text|
  step %Q{I should see "#{text}"}
end

Then('I should see {string} on the session details page') do |text|
  step %Q{I should see "#{text}"}
end


# Pre-book a learner into a given session

Given('the following learners are booked into sessions:') do |table|
  table.hashes.each do |row|
    # Create/find learner
    learner = Learner.find_or_create_by!(email: row['learner_email']) do |l|
      l.password   = 'password123'
      l.first_name = 'Booked'
      l.last_name  = 'Learner'
    end

    # Find the tutor and subject using same conventions as
    # "the following tutors and sessions exist"
    subject_name = row['subject']
    subject      = Subject.find_by!(name: subject_name)

    tutor_name = row['tutor_name'].to_s.strip
    names      = tutor_name.split
    first      = names[0..-2].join(' ').presence || names.first
    last       = names.last

    tutor_learner = Learner.find_by!(first_name: first, last_name: last)
    tutor         = Tutor.find_by!(learner: tutor_learner)

    start_time = Time.iso8601(row['session_start'])
    end_time   = Time.iso8601(row['session_end'])

    session = TutorSession.find_by!(
      tutor:    tutor,
      subject:  subject,
      start_at: start_time,
      end_at:   end_time
    )

    # Only create the booking if the session is not already full
    active_count = session.session_attendees.where(cancelled: false).count
    if active_count < session.capacity
        SessionAttendee.create!(
            tutor_session: session,
            learner:       learner,
            cancelled:     false
        )
    end

  end
end


# Log in as a learner with a specific email

Given('I am a signed-in learner with email {string}') do |email|
  password = 'password123'

  @current_learner = Learner.find_or_create_by!(email: email) do |l|
    l.password   = password
    l.first_name ||= email.split('@').first.titleize
    l.last_name  ||= 'Learner'
  end

  visit new_login_path
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'
end


# Button visibility

Then('I should not see a {string} button for that session') do |label|
  expect(page).not_to have_button(label)
end


# Navigation / cancel flow – reuse existing behavior as much as possible

When('I go to my learner sessions page') do
  visit learner_sessions_path
end

When('I choose to cancel that booking') do
  # On the learner sessions page there is a list of upcoming sessions;
  # click the first "Cancel" link (this is fine for our controlled scenario).
  first(:link, 'Cancel').click
end

When('I visit the session details page again for tutor {string} from {string} to {string}') do |tutor_name, start_iso, end_iso|
  names      = tutor_name.to_s.strip.split
  first      = names[0..-2].join(' ').presence || names.first
  last       = names.last

  tutor_learner = Learner.find_by!(first_name: first, last_name: last)
  tutor         = Tutor.find_by!(learner: tutor_learner)

  start_time = Time.iso8601(start_iso)
  end_time   = Time.iso8601(end_iso)

  session = TutorSession.find_by!(
    tutor:    tutor,
    start_at: start_time,
    end_at:   end_time
  )

  visit session_path(session)
end
