require 'time'

Given('the learner has the following bookings:') do |table|
  # Ensure we have a current learner to attach bookings to.
  @current_learner ||= Learner.find_or_create_by!(email: 'learner@example.com') do |l|
    l.password   = 'password123'
    l.first_name = 'Example'
    l.last_name  = 'Learner'
  end

  table.hashes.each do |row|
    subject_name = row.fetch('subject')
    tutor_name   = row.fetch('tutor_name')
    start_time   = Time.iso8601(row.fetch('start_at'))
    end_time     = Time.iso8601(row.fetch('end_at'))
    status       = row['status'].presence || 'scheduled'
    attended_raw = row['attended'].presence

    # Subject with a simple generated code if needed
    subject = Subject.find_or_create_by!(name: subject_name) do |s|
      s.code = subject_name.parameterize.upcase.first(6)
    end

    # Build tutor via an underlying learner, consistent with other steps
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

    # Create the underlying session
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

    attendee = SessionAttendee.find_or_create_by!(
      tutor_session: tutor_session,
      learner: @current_learner
    )

    # Set attendance if provided
    if attended_raw
      attendee.update!(
        attended: ActiveModel::Type::Boolean.new.cast(attended_raw)
      )
    end
  end
end

Then('I should be on the learner upcoming sessions page') do
  expect(page).to have_current_path(learner_sessions_path)
end

Then('I should be on the learner past sessions page') do
  expect(page).to have_current_path(past_learner_sessions_path)
end

When('I visit the "My Sessions" page directly') do
  visit learner_sessions_path
end