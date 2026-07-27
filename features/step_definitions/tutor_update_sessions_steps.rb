Then('I should see the edit session page') do
  expect(page).to have_content('Edit Session')
end

Then('I should see a link with text {string} pointing to {string}') do |link_text, content|
  expect(page).to have_link(link_text, href: content)
end

When('I make the update') do
  click_button('update') if page.has_button?('update')
end

When('I cancel the update') do
  click_link ('Cancel')
end

When('I click Edit for the upcoming session starting at {string}') do |start_iso|
  start_str = Time.iso8601(start_iso).utc.iso8601

  within('.upcoming-sessions') do
    li = page.find('li.session', text: start_str)
    within(li) do
      click_link 'Edit'
    end
  end
end

When('I enter the meeting link {string}') do |link|
  fill_in 'tutor_session_meeting_link', with: link
end

# @other_session referenced in tutor_cancel_session_steps.rb
When("I attempt to edit that other tutor's booking directly") do
  visit edit_tutor_session_path(@other_session)
end

When("I attempt to edit that past session directly") do
  past_session = TutorSession.where(status: 'completed').last
  visit edit_tutor_session_path(past_session)
end
