Given ('the following tutor applications exist:') do |table|
  table.hashes.each do |row|
    learner_first, learner_last = row['learner'].split(' ', 2)
    learner = Learner.find_by!(first_name: learner_first, last_name: learner_last)

    TutorApplication.find_or_create_by!(
      learner: learner,
      reason: row['reason'],
      status: "pending")
  end
end

Given("I visit the manage applications page") do
  visit admin_tutor_applications_pending_path
end

Given("there are no pending applications in the database") do
  TutorApplication.destroy_all
end

When('I press the {string} button for {string}') do |button_text, learner_name|
  learner_first, learner_last = learner_name.split(' ', 2)
  learner = Learner.find_by!(first_name: learner_first, last_name: learner_last)
  application = TutorApplication.find_by!(learner: learner)

  within("#application_container_#{application.id}") do
    click_button button_text
  end
end

Then('the application for {string} should be deleted') do |learner_name|
  learner_first, learner_last = learner_name.split(' ', 2)
  learner = Learner.find_by!(first_name: learner_first, last_name: learner_last)

  expect(TutorApplication.exists?(learner: learner)).to be false
end

Then("I should see the manage applications page") do
  expect(page).to have_content('Manage Tutor Applications')
end

Then('the application status for {string} should be {string}') do |learner_name, status|
  learner_first, learner_last = learner_name.split(' ', 2)
  learner = Learner.find_by!(first_name: learner_first, last_name: learner_last)
  application = TutorApplication.find_by!(learner: learner)
  expect(application.status).to eq(status)
end

Then(/"([^"]*)" should (not )?be a tutor/) do |learner_name, not_be|
  learner_first, learner_last = learner_name.split(' ', 2)
  learner = Learner.find_by!(first_name: learner_first, last_name: learner_last)
  if not_be
    expect(Tutor.exists?(learner: learner)).to be_falsey
  else
    expect(Tutor.exists?(learner: learner)).to be_truthy
  end
end

Then(/I should (not )?see a tutor application for "([^"]*)"/) do |not_see, learner_name|
  learner_first, learner_last = learner_name.split(' ', 2)
  learner = Learner.find_by!(first_name: learner_first, last_name: learner_last)
  application = TutorApplication.find_by(learner: learner) # <- use find_by, not find_by!

  if not_see
    expect(application).to be_nil
  else
    expect(page).to have_css("#application_container_#{application.id}")
  end
end

Then('I should not see any tutor applications') do
  expect(page).not_to have_css('tr.application-row')
end
