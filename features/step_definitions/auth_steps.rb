Given("I am on the home page") do
  visit home_path
end

Given("I am on the sign-up page") do
  visit new_learner_path
end

Given("I am on the login page") do
  visit new_login_path
end

When("I fill in {string} with {string}") do |field, value|
  fill_in field, with: value
end

When("I press {string}") do |button|
  click_button button
end

Then("I should see a message {string}") do |message|
  expect(page).to have_content(message)
end

Then("I should see an error message {string}") do |message|
  expect(page).to have_content(message)
end

Then(/^I should be redirected to (?:the )?login page$/) do
  expect(page).to have_current_path(login_path)
end

Then("I should be redirected to the home page") do
  expect(page).to have_current_path(home_path)
end

Given("an account exists for {string} with password {string}") do |email, password|
  Learner.find_or_create_by!(email: email) do |learner|
    learner.password = password
    learner.password_confirmation = password
  end
end

Given("I am logged in as {string}") do |email|
  Learner.find_or_create_by!(email: email) do |learner|
    learner.password = "password"
    learner.password_confirmation = "password"
  end

  visit new_login_path
  fill_in "Email", with: email
  fill_in "Password", with: "password"
  click_button "Log in"

  expect(page).to have_current_path(home_path)
end