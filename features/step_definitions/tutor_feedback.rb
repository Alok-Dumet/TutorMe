require 'time'

Given('I am a logged-in tutor') do
  @learner = Learner.create!(
    first_name: 'Test',
    last_name:  'Tutor',
    email:      'tutor@example.com',
    password:   'password'
  )
  @tutor = Tutor.create!(learner: @learner, bio: 'Math & CS')

  visit login_path
  fill_in 'Email', with: @learner.email
  fill_in 'Password', with: 'password'
  click_button 'Log in'
end

Given('the following learners exist:') do |table|
  table.hashes.each do |row|
    Learner.create!(
      email:      row['email'],
      password:   row['password'],
      first_name: row['first_name'],
      last_name:  row['last_name']
    )
  end
end

Given('the following subjects exist:') do |table|
  table.hashes.each do |row|
    Subject.create!(name: row['name'], code: row['code'])
  end
end

Given('the following sessions exist:') do |table|
  table.hashes.each do |row|
    subject = Subject.find_by!(name: row['subject'])
    TutorSession.create!(
      tutor:        @tutor,
      subject:      subject,
      start_at:     Time.iso8601(row['start_at']),
      end_at:       Time.iso8601(row['end_at']),
      capacity:     5,
      status:       row['status'] || 'completed',
      meeting_link: 'https://meet.example/test'
    )
  end
end

Given('the following feedback exists:') do |table|
  table.hashes.each do |row|
    subject = Subject.find_by!(name: row['session'])
    tutor_session = TutorSession.where(tutor: @tutor, subject: subject).order(:start_at).first
    learner = Learner.find_by!(email: row['learner_email'])
      Feedback.create!(
        tutor_session: tutor_session,
        learner:       learner,
        tutor:         @tutor,
        rating:        row['score'].to_i,
        comment:       row['comment']
      )
  end
end

Given('I am on the Tutor Feedback page') do
  visit tutor_feedbacks_path
end

When('I view my feedback list') do
  visit tutor_feedbacks_path
end

When('I filter feedback by subject {string}') do |subject_name|
  select subject_name, from: 'Subject' if page.has_select?('Subject')
  click_button 'Apply Filters' if page.has_button?('Apply Filters')
end

Given('I am a tutor with no feedback yet') do
  @learner = Learner.create!(
    first_name: 'Empty',
    last_name:  'Tutor',
    email:      'empty_tutor@example.com',
    password:   'password'
  )
  @tutor = Tutor.create!(learner: @learner, bio: 'N/A')

  visit login_path
  fill_in 'Email', with: @learner.email
  fill_in 'Password', with: 'password'
  click_button 'Log in'
end

When('I visit the Tutor Feedback page') do
  visit tutor_feedbacks_path
end

Given('another tutor exists') do
  other_learner = Learner.create!(
    first_name: 'Other',
    last_name:  'Tutor',
    email:      'other_tutor@example.com',
    password:   'password'
  )
  @other_tutor = Tutor.create!(learner: other_learner, bio: 'Chemistry')
end

When('I try to access that tutor’s feedback page') do
  visit "#{tutor_feedbacks_path}?tutor_id=#{@other_tutor.id}"
end

Given('I have more than 10 feedback entries') do
  subject = Subject.first || Subject.create!(name: 'Temp', code: 'TEMP')
  12.times do |i|
    # Create non-overlapping sessions: each session is 1 hour, spaced 2 hours apart
    start_time = Time.zone.now - (i * 2).hours - 1.hour
    end_time = start_time + 1.hour
    
    tutor_session = TutorSession.create!(
      tutor:        @tutor,
      subject:      subject,
      start_at:     start_time,
      end_at:       end_time,
      capacity:     5,
      status:       'completed',
      meeting_link: 'https://meet.example/test'
    )
    learner = Learner.create!(
      first_name: "L#{i}",
      last_name:  'User',
      email:      "l#{i}@example.com",
      password:   'password'
    )
    
    # Create session attendee with attended and feedback_submitted set to true
    attendee = SessionAttendee.find_or_create_by!(
      tutor_session: tutor_session,
      learner: learner
    )
    attendee.update!(attended: true, feedback_submitted: true)
    
    Feedback.create!(
      tutor_session: tutor_session,
      learner:       learner,
      tutor:         @tutor,
      rating:        3 + (i % 3),
      comment:       "Comment #{i}"
    )
  end
end

Then('I should see only {int} feedback items displayed') do |n|
  expect(page).to have_css('.feedback-row', count: n)
end

Then('I should see pagination controls') do
  expect(page).to have_css('.pagination')
end

Then('I should see text {string}') do |text|
  expect(page).to have_content(text)
end

Then('I should not see text {string}') do |text|
  expect(page).not_to have_content(text)
end