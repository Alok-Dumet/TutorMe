require 'time'

When('I click "Cancel" for the upcoming session starting at {string}') do |start_iso|
  start_str = Time.iso8601(start_iso).utc.iso8601

  within('.upcoming-sessions') do
    li = page.find('li.session', text: start_str)
    within(li) do
      click_link 'Cancel'
    end
  end
end

Then('I should see the cancel confirmation page') do
  expect(page).to have_content('Cancel Session')
  expect(page).to have_content('Are you sure you want to cancel this session?')
end

When('I choose to confirm the cancellation') do
  click_button 'Yes'
end

When('I choose not to cancel the session') do
  click_button 'No'
end

Given('another learner has a booking for:') do |table|
  # Create another learner whose booking should not be cancellable by @current_learner.
  other_learner = Learner.find_or_create_by!(email: 'other_learner@example.com') do |l|
    l.password   = 'password123'
    l.first_name = 'Other'
    l.last_name  = 'Learner'
  end

  table.hashes.each do |row|
    subject_name = row.fetch('subject')
    tutor_name   = row.fetch('tutor_name')
    start_time   = Time.iso8601(row.fetch('start_at'))
    end_time     = Time.iso8601(row.fetch('end_at'))
    status       = row['status'].presence || 'scheduled'

    subject = Subject.find_or_create_by!(name: subject_name) do |s|
      s.code = subject_name.parameterize.upcase.first(6)
    end

    names = tutor_name.to_s.strip.split
    first = (names[0..-2].join(' ').presence || names.first)
    last  = names.last

    tutor_learner = Learner.find_or_create_by!(
      email: "#{first.downcase.gsub(/\s+/, '_')}.#{last.downcase}@example.com"
    ) do |l|
      l.password   = 'password123'
      l.first_name = first
      l.last_name  = last
    end

    tutor = Tutor.find_or_create_by!(learner: tutor_learner)

    tutor_session = TutorSession.find_or_create_by!(
      tutor: tutor,
      subject: subject,
      start_at: start_time,
      end_at: end_time
    ) do |s|
      s.capacity     = 3
      s.status       = status
      s.meeting_link = s.meeting_link || 'https://example.org/meet/booking'
    end

    @other_booking = SessionAttendee.find_or_create_by!(
      tutor_session: tutor_session,
      learner: other_learner
    )
  end
end

When("I attempt to cancel that other learner's booking directly") do
  visit cancel_learner_session_path(@other_booking)
end

When('I attempt to cancel that past booking directly') do
  booking = SessionAttendee
              .joins(:tutor_session)
              .where(learner: @current_learner)
              .order('tutor_sessions.start_at ASC')
              .first

  visit cancel_learner_session_path(booking)
end