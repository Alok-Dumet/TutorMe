Given('my bio is {string}') do |string|
  @current_tutor.update!(bio: string)
end

When('I change the bio to {string}') do |string|
    fill_in 'bio', with: string
end

When('I change the bio to a string with {int} characters') do |int|
    new_bio = 'a' * int
    fill_in 'bio', with: new_bio
end

When('I visit my tutor profile page') do
    visit tutor_path(@current_tutor)
end