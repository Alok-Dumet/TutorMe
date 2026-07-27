require "securerandom"

Given("I have a completed session with {string} where I was marked present") do |tutor_name|
  # Use the learner created by "I am a signed-in learner"
  learner = @current_learner || @learner
  raise "current_learner is nil – make sure Background has 'Given I am a signed-in learner'" if learner.nil?

  # Split tutor name like "Michael Chen"
  names = tutor_name.split
  first = names[0..-2].join(" ")
  last  = names.last || ""

  tutor_learner = Learner.find_or_create_by!(
    email: "#{first.downcase.gsub(' ', '_')}.#{last.downcase}@example.com"
  ) do |l|
    l.password   = "password123"
    l.first_name = first
    l.last_name  = last
  end

  @tutor = Tutor.find_or_create_by!(learner: tutor_learner) do |t|
    t.bio ||= "Test tutor"
  end

  subject = Subject.first || Subject.create!(name: "Statistics", code: "STAT101")

  @tutor_session = TutorSession.where(
    tutor:   @tutor,
    subject: subject,
    status:  "Completed"
  ).where("end_at < ?", Time.current).first

  unless @tutor_session
    @tutor_session = TutorSession.create!(
      tutor:    @tutor,
      subject:  subject,
      start_at: 2.days.ago.change(min: 0, sec: 0),
      end_at:   2.days.ago.change(min: 59, sec: 59),
      capacity: 5,
      status:   "Completed",
      meeting_link: "https://zoom.us/feedback-session"
    )
  end

  # Reuse or create the attendee and mark present
  @attendee = SessionAttendee.find_or_create_by!(
    tutor_session: @tutor_session,
    learner:       learner
  ) do |sa|
    sa.attended = true
  end
end

Given("I have a completed session with {string} where I was marked absent") do |tutor_name|
  # Background already set up the "present" session, but in case someone
  # reuses this step elsewhere, fall back to the present step.
  if @attendee.nil? || @tutor_session.nil?
    step %{I have a completed session with "#{tutor_name}" where I was marked present}
  end

  @attendee.update!(attended: false)
end

# ---------- Navigation / UI steps ----------

When("I navigate to the feedback form for {string}") do |_tutor_name|
  # @tutor_session was created in the "I have a completed session..." Given step
  raise "@tutor_session is nil – make sure the Background creates it first" if @tutor_session.nil?
  # Use the NESTED route: /sessions/:session_id/feedbacks/new
  visit new_session_feedback_path(@tutor_session)
end

When("I visit the session page for {string}") do |_tutor_name|
  raise "@tutor_session is nil – make sure the Background creates it first" if @tutor_session.nil?
  visit session_path(@tutor_session)
end

# ---------- Form interactions ----------

When("I select a rating of {string}") do |rating|
  # assumes radio buttons labelled 1..5
  choose(rating)
end

Then("I should not see {string}") do |text|
  expect(page).not_to have_content(text)
end