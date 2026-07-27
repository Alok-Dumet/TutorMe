Given('I am on new session page,') do
  visit new_session_path
end

When('I fill in the session start time with {string}') do |datetime_string|
  value = datetime_string.chomp("Z") 
  fill_in 'Start Time', with: value
  
  @start_time = Time.zone.parse(datetime_string)
end

When('I set the duration to {int} hour and {int} minutes') do |hours, minutes|
  select hours.to_s, from: 'duration_hours'
  select minutes.to_s, from: 'duration_minutes'
  
  if @start_time
    @end_time = @start_time + hours.hours + minutes.minutes
  end
end

When('I fill in {string} from {string}') do |value, field|
  fill_in field, with: value
  @subject = value
end

Then('I should see the session on the page') do
  expect(page).to have_content(TutorSession.last.subject.name)
end

Then('I should see an error message saying it is missing information') do
  expect(page).to have_content("can't be blank")
end

Then('I should see an error message that there is a time conflict') do
  expect(page).to have_content("Session overlaps with existing session")
end

Then("I am on the session's show page") do
  expect(page).to have_current_path(session_path(TutorSession.last))
end

Given('the following session exists:') do |table|
  table.hashes.each do |row|
    subj = Subject.find_or_create_by!(name: row['subject'])
    tutor = Tutor.find_by!(learner: @current_learner)

    @current_session = TutorSession.find_or_create_by!(
      tutor: tutor,
      subject: subj,
      start_at: Time.iso8601(row['start_at']),
      end_at: Time.iso8601(row['end_at'])
    ) do |s|
      s.capacity = row['capacity'].to_i
      s.status = row['status']
      s.meeting_link = "https://zoom.us/test-session"
    end
  end  
end

When('this session overlaps with existing session') do
  overlap = TutorSession
              .where(tutor: Tutor.find_by(learner: @current_learner))
              .where("start_at < ? AND end_at > ?", @end_time, @start_time)
  expect(overlap.exists?).to be true
end

Then('I should see the message {string}') do |message|
  expect(page).to have_content(message)
end

When('I select {string} from the Subject dropdown') do |subject_name|
  select subject_name, from: 'Subject'
end