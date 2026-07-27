When('I click {string} for the upcoming sessions starting at {string}') do |_text, start_time|
  start_str = Time.iso8601(start_time).utc.iso8601  # Use ISO8601 format to match view

  within('.upcoming-sessions') do
    session_li = page.find('li.session', text: start_str)
    within(session_li) do
      click_link 'Cancel'
    end
  end
end


Given('the following session exists for another tutor:') do |table|
  other_learner = Learner.find_or_create_by!(email: 'other_learner@example.com') do |l|
    l.password   = 'password123'
    l.first_name = 'Other'
    l.last_name  = 'Learner'
  end

  other_tutor = Tutor.find_or_create_by!(learner: other_learner)

  table.hashes.each do |row|
    subject = Subject.find_or_create_by!(name: row['subject'])

    @other_session = TutorSession.create!(
      tutor:    other_tutor,
      subject:  subject,
      start_at: Time.iso8601(row['start_at']),
      end_at:   Time.iso8601(row['end_at']),
      capacity: row['capacity'].to_i,
      status:   row['status'],
      meeting_link: "https://zoom.us/other-tutor-session"
    )
  end
end

When("I attempt to cancel that past session directly") do
  past_session = TutorSession.where(status: 'completed').last
  visit cancel_tutor_session_path(past_session)
end


When("I attempt to cancel that other tutor's booking directly") do
  visit cancel_tutor_session_path(@other_session)
end

When("I confirm the cancellation") do
  click_button 'Yes'
end

Then('the session should have status {string}') do |expected_status|
  @current_session.reload
  expect(@current_session.status).to eq(expected_status)
end