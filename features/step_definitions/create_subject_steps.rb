Given('I am a signed-in admin') do
  email, password = 'admin@example.com', 'password123'
  Admin.find_or_create_by!(email: email) { |a| a.password = password }
  visit new_login_path
  fill_in 'Email', with: email
  fill_in 'Password', with: password
  click_button 'Log in'
end

Given('a subject already exists with name {string} and code {string}') do |name, code|
  Subject.find_or_create_by!(code: code) { |s| s.name = name }
end

When('I visit the "New Subject" page') do
  visit new_subject_path
end

When('I fill {string} with {string}') do |label, value|
  fill_in label, with: value
end

When('I leave {string} blank') do |label|
  fill_in label, with: ''
end

When('I click {string}') do |text|
  click_button text
end

