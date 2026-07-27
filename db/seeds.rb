puts "Resetting domain data..."

# Clear domain tables in dependency order
[Feedback,
 SessionAttendee,
 TutorSession,
 Teach,
 TutorApplication,
 Tutor,
 Subject,
 Learner,
 Admin].each(&:delete_all)

def ts_time(str)
  if Time.zone
    Time.zone.parse(str)
  else
    Time.parse(str)
  end
end

ApplicationRecord.transaction do
  # Admins (exactly 2)
  puts "Creating admins..."

  admin_1 = Admin.create!(
    first_name: "Alice",
    last_name:  "Admin",
    email:      "admin1@example.com",
    password:   "AdminPass1!",
    password_confirmation: "AdminPass1!"
  )

  admin_2 = Admin.create!(
    first_name: "Bob",
    last_name:  "Manager",
    email:      "admin2@example.com",
    password:   "AdminPass2!",
    password_confirmation: "AdminPass2!"
  )

  # Learners (20)
  puts "Creating learners..."

  learner_data = [
    { first_name: "Emma",      last_name: "Johnson",  email: "emma.johnson@example.com" },
    { first_name: "Liam",      last_name: "Smith",    email: "liam.smith@example.com" },
    { first_name: "Olivia",    last_name: "Brown",    email: "olivia.brown@example.com" },
    { first_name: "Noah",      last_name: "Davis",    email: "noah.davis@example.com" },
    { first_name: "Ava",       last_name: "Wilson",   email: "ava.wilson@example.com" },
    { first_name: "William",   last_name: "Taylor",   email: "william.taylor@example.com" },
    { first_name: "Sophia",    last_name: "Anderson", email: "sophia.anderson@example.com" },
    { first_name: "James",     last_name: "Thomas",   email: "james.thomas@example.com" },
    { first_name: "Isabella",  last_name: "Martinez", email: "isabella.martinez@example.com" },
    { first_name: "Benjamin",  last_name: "Harris",   email: "benjamin.harris@example.com" },
    { first_name: "Mia",       last_name: "Clark",    email: "mia.clark@example.com" },
    { first_name: "Lucas",     last_name: "Lewis",    email: "lucas.lewis@example.com" },
    { first_name: "Charlotte", last_name: "Young",    email: "charlotte.young@example.com" },
    { first_name: "Henry",     last_name: "King",     email: "henry.king@example.com" },
    { first_name: "Amelia",    last_name: "Wright",   email: "amelia.wright@example.com" },
    { first_name: "Alexander", last_name: "Scott",    email: "alexander.scott@example.com" },
    { first_name: "Harper",    last_name: "Green",    email: "harper.green@example.com" },
    { first_name: "Daniel",    last_name: "Baker",    email: "daniel.baker@example.com" },
    { first_name: "Evelyn",    last_name: "Hall",     email: "evelyn.hall@example.com" },
    { first_name: "Michael",   last_name: "Adams",    email: "michael.adams@example.com" }
  ]

  learners = learner_data.each_with_index.map do |attrs, index|
    Learner.create!(
      attrs.merge(
        password:              "LearnerPass#{index + 1}!",
        password_confirmation: "LearnerPass#{index + 1}!"
      )
    )
  end

  emma, liam, olivia, noah, ava, william, sophia, james, isabella, benjamin,
    mia, lucas, charlotte, henry, amelia, alexander, harper, daniel,
    evelyn, michael = learners

  # Subjects (12)
  puts "Creating subjects..."

  subject_data = [
    { name: "Calculus I",                code: "MATH-UY 1012",  description: "Limits, derivatives, and basic applications." },
    { name: "Calculus II",               code: "MATH-UY 1022",  description: "Series, convergence, and advanced integration." },
    { name: "Linear Algebra",            code: "MATH-UY 2034",  description: "Matrices, vector spaces, and eigenvalues." },
    { name: "Discrete Mathematics",      code: "MATH-UY 2314",  description: "Logic, sets, combinatorics, and graphs." },
    { name: "Introduction to CS",        code: "CS-UY 1113",    description: "Introductory programming and problem solving." },
    { name: "Data Structures",           code: "CS-UY 1134",    description: "Lists, trees, hash tables, and complexity." },
    { name: "Algorithms",                code: "CS-UY 2413",    description: "Algorithm design and analysis." },
    { name: "Physics I",                 code: "PH-UY 1011",    description: "Mechanics and motion." },
    { name: "Chemistry I",               code: "CM-UY 1004",    description: "Atoms, bonding, and stoichiometry." },
    { name: "English Composition",       code: "ENG-UY 1004",   description: "Academic writing and argumentation." },
    { name: "Statistics",                code: "STAT-UY 2132",  description: "Probability and statistical inference." },
    { name: "Introduction to Economics", code: "ECON-UY 1013",  description: "Micro- and macroeconomic principles." }
  ]

  subjects = subject_data.map { |attrs| Subject.create!(attrs) }

  calc1, calc2, lin_alg, disc_math, intro_cs, data_structures, algorithms,
    physics1, chem1, english_comp, statistics, economics = subjects

  # Tutor applications (>10)
  puts "Creating tutor applications..."

  tutor_applications = []

  approved_applicants = [
    emma, liam, olivia, noah, ava, william, sophia, james, isabella, benjamin, mia
  ]

  pending_applicants = [
    lucas, charlotte, henry
  ]

  approved_applicants.each do |learner|
    tutor_applications << TutorApplication.create!(
      learner: learner,
      reason:  "#{learner.first_name} #{learner.last_name} has strong grades and prior experience helping classmates.",
      status:  "approved"
    )
  end

  pending_applicants.each do |learner|
    tutor_applications << TutorApplication.create!(
      learner: learner,
      reason:  "#{learner.first_name} #{learner.last_name} is interested in tutoring in future semesters.",
      status:  "pending"
    )
  end

  # Tutors (11)
  puts "Creating tutors..."

  tutors = {}

  tutors[:anna_math] = Tutor.create!(
    learner: emma,
    bio:     "Sophomore math/CS student focusing on first-year calculus and linear algebra."
  )

  tutors[:brian_cs] = Tutor.create!(
    learner: liam,
    bio:     "Computer Science major who enjoys teaching data structures and algorithms."
  )

  tutors[:claire_stats] = Tutor.create!(
    learner: olivia,
    bio:     "CS and physics student who helps with intro programming and statistics."
  )

  tutors[:david_physics] = Tutor.create!(
    learner: noah,
    bio:     "Math and economics double major running physics and probability reviews."
  )

  tutors[:ava_physics] = Tutor.create!(
    learner: ava,
    bio:     "First-year physics student available for mechanics problem-solving."
  )

  tutors[:william_cs] = Tutor.create!(
    learner: william,
    bio:     "Junior CS major preparing to host data structures labs."
  )

  tutors[:sophia_math] = Tutor.create!(
    learner: sophia,
    bio:     "Math & CS double major planning advanced math review sessions."
  )

  tutors[:james_physics] = Tutor.create!(
    learner: james,
    bio:     "Physics major who will host introductory physics help hours."
  )

  tutors[:isabella_chem] = Tutor.create!(
    learner: isabella,
    bio:     "Chemistry major focusing on first-year general chemistry."
  )

  tutors[:benjamin_econ] = Tutor.create!(
    learner: benjamin,
    bio:     "Economics student who enjoys micro/macro problem sessions."
  )

  tutors[:mia_english] = Tutor.create!(
    learner: mia,
    bio:     "English major offering composition and essay feedback."
  )

  tutor_anna   = tutors[:anna_math]
  tutor_brian  = tutors[:brian_cs]
  tutor_claire = tutors[:claire_stats]
  tutor_david  = tutors[:david_physics]

  # Teaches (>10)
  puts "Creating teach relationships..."

  teaches = []

  # Anna: calculus + linear algebra
  teaches << Teach.create!(tutor: tutor_anna,   subject: calc1)
  teaches << Teach.create!(tutor: tutor_anna,   subject: calc2)
  teaches << Teach.create!(tutor: tutor_anna,   subject: lin_alg)

  # Brian: discrete, data structures, algorithms, intro CS
  teaches << Teach.create!(tutor: tutor_brian,  subject: disc_math)
  teaches << Teach.create!(tutor: tutor_brian,  subject: data_structures)
  teaches << Teach.create!(tutor: tutor_brian,  subject: algorithms)
  teaches << Teach.create!(tutor: tutor_brian,  subject: intro_cs)

  # Claire: statistics, economics, chemistry
  teaches << Teach.create!(tutor: tutor_claire, subject: statistics)
  teaches << Teach.create!(tutor: tutor_claire, subject: economics)
  teaches << Teach.create!(tutor: tutor_claire, subject: chem1)

  # David: physics, English, calculus
  teaches << Teach.create!(tutor: tutor_david,  subject: physics1)
  teaches << Teach.create!(tutor: tutor_david,  subject: english_comp)
  teaches << Teach.create!(tutor: tutor_david,  subject: calc1)

  # Other tutors so they appear in searches/filters
  teaches << Teach.create!(tutor: tutors[:ava_physics],   subject: physics1)
  teaches << Teach.create!(tutor: tutors[:william_cs],    subject: data_structures)
  teaches << Teach.create!(tutor: tutors[:sophia_math],   subject: lin_alg)
  teaches << Teach.create!(tutor: tutors[:james_physics], subject: physics1)
  teaches << Teach.create!(tutor: tutors[:isabella_chem], subject: chem1)
  teaches << Teach.create!(tutor: tutors[:benjamin_econ], subject: economics)
  teaches << Teach.create!(tutor: tutors[:mia_english],   subject: english_comp)

  # Tutor sessions (>10)
  puts "Creating tutor sessions..."

  tutor_sessions = []

  # S1 - Past completed
  tutor_sessions << TutorSession.create!(
    tutor:        tutor_anna,
    subject:      calc1,
    start_at:     ts_time("2025-11-02 10:00"),
    end_at:       ts_time("2025-11-02 11:00"),
    capacity:     4,
    status:       "completed",
    meeting_link: "https://tutoring.example.com/calc1-limits-review"
  )

  # S2 - Past cancelled by tutor
  tutor_sessions << TutorSession.create!(
    tutor:        tutor_anna,
    subject:      calc2,
    start_at:     ts_time("2025-11-05 14:00"),
    end_at:       ts_time("2025-11-05 15:00"),
    capacity:     4,
    status:       "cancelled",
    meeting_link: "https://tutoring.example.com/calc2-series-clinic"
  )

  # S3 - Future scheduled
  tutor_sessions << TutorSession.create!(
    tutor:        tutor_anna,
    subject:      lin_alg,
    start_at:     ts_time("2026-01-06 10:00"),
    end_at:       ts_time("2026-01-06 11:30"),
    capacity:     5,
    status:       "scheduled",
    meeting_link: "https://tutoring.example.com/linear-algebra-review"
  )

  # S4 - Past completed
  tutor_sessions << TutorSession.create!(
    tutor:        tutor_brian,
    subject:      data_structures,
    start_at:     ts_time("2025-11-03 13:00"),
    end_at:       ts_time("2025-11-03 14:30"),
    capacity:     3,
    status:       "completed",
    meeting_link: "https://tutoring.example.com/data-structures-lists-stacks"
  )

  # S5 - Future scheduled
  tutor_sessions << TutorSession.create!(
    tutor:        tutor_brian,
    subject:      algorithms,
    start_at:     ts_time("2026-02-01 09:00"),
    end_at:       ts_time("2026-02-01 10:00"),
    capacity:     3,
    status:       "scheduled",
    meeting_link: "https://tutoring.example.com/algorithms-graphs-session"
  )

  # S6 - Future open
  tutor_sessions << TutorSession.create!(
    tutor:        tutor_brian,
    subject:      intro_cs,
    start_at:     ts_time("2026-02-05 15:00"),
    end_at:       ts_time("2026-02-05 16:00"),
    capacity:     4,
    status:       "open",
    meeting_link: "https://tutoring.example.com/introcs-debugging-clinic"
  )

  # S7 - Past completed
  tutor_sessions << TutorSession.create!(
    tutor:        tutor_claire,
    subject:      statistics,
    start_at:     ts_time("2025-11-10 16:00"),
    end_at:       ts_time("2025-11-10 17:00"),
    capacity:     3,
    status:       "completed",
    meeting_link: "https://tutoring.example.com/statistics-confidence-intervals"
  )

  # S8 - Past completed
  tutor_sessions << TutorSession.create!(
    tutor:        tutor_claire,
    subject:      economics,
    start_at:     ts_time("2025-11-20 11:00"),
    end_at:       ts_time("2025-11-20 12:00"),
    capacity:     2,
    status:       "completed",
    meeting_link: "https://tutoring.example.com/econ-midterm-review"
  )

  # S9 - Future cancelled (tutor cancels)
  tutor_sessions << TutorSession.create!(
    tutor:        tutor_claire,
    subject:      chem1,
    start_at:     ts_time("2026-01-07 14:00"),
    end_at:       ts_time("2026-01-07 15:00"),
    capacity:     2,
    status:       "cancelled",
    meeting_link: "https://tutoring.example.com/chemistry-stoichiometry"
  )

  # S10 - Past completed
  tutor_sessions << TutorSession.create!(
    tutor:        tutor_david,
    subject:      physics1,
    start_at:     ts_time("2025-12-01 11:00"),
    end_at:       ts_time("2025-12-01 12:00"),
    capacity:     4,
    status:       "completed",
    meeting_link: "https://tutoring.example.com/physics1-newtons-laws"
  )

  # S11 - Future scheduled
  tutor_sessions << TutorSession.create!(
    tutor:        tutor_david,
    subject:      english_comp,
    start_at:     ts_time("2026-01-10 10:00"),
    end_at:       ts_time("2026-01-10 11:00"),
    capacity:     3,
    status:       "scheduled",
    meeting_link: "https://tutoring.example.com/english-essay-clinic"
  )

  # S12 - Future open
  tutor_sessions << TutorSession.create!(
    tutor:        tutor_david,
    subject:      calc1,
    start_at:     ts_time("2026-02-10 10:00"),
    end_at:       ts_time("2026-02-10 11:00"),
    capacity:     5,
    status:       "open",
    meeting_link: "https://tutoring.example.com/calc1-exam-review"
  )

  s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12 = tutor_sessions

  # SessionAttendees
  puts "Creating session attendees..."

  session_attendees = []

  session_attendees << SessionAttendee.create!(
    tutor_session:     s1,
    learner:           michael,
    attended:          true,
    cancelled:         false,
    feedback_submitted:true
  )
  session_attendees << SessionAttendee.create!(
    tutor_session:     s1,
    learner:           liam,
    attended:          true,
    cancelled:         false,
    feedback_submitted:true
  )
  session_attendees << SessionAttendee.create!(
    tutor_session:     s1,
    learner:           olivia,
    attended:          true,
    cancelled:         false,
    feedback_submitted:true
  )
  session_attendees << SessionAttendee.create!(
    tutor_session:     s1,
    learner:           noah,
    attended:          true,
    cancelled:         false,
    feedback_submitted:true
  )

  # S2
  session_attendees << SessionAttendee.create!(
    tutor_session:     s2,
    learner:           ava,
    attended:          false,
    cancelled:         true,
    feedback_submitted:false
  )
  session_attendees << SessionAttendee.create!(
    tutor_session:     s2,
    learner:           william,
    attended:          false,
    cancelled:         false,
    feedback_submitted:false
  )

  # S3
  session_attendees << SessionAttendee.create!(
    tutor_session:     s3,
    learner:           sophia,
    attended:          false,
    cancelled:         false,
    feedback_submitted:false
  )

  # S4
  session_attendees << SessionAttendee.create!(
    tutor_session:     s4,
    learner:           james,
    attended:          true,
    cancelled:         false,
    feedback_submitted:true
  )
  session_attendees << SessionAttendee.create!(
    tutor_session:     s4,
    learner:           isabella,
    attended:          true,
    cancelled:         false,
    feedback_submitted:false
  )
  session_attendees << SessionAttendee.create!(
    tutor_session:     s4,
    learner:           benjamin,
    attended:          false,
    cancelled:         false,
    feedback_submitted:false
  )

  # S5
  session_attendees << SessionAttendee.create!(
    tutor_session:     s5,
    learner:           mia,
    attended:          false,
    cancelled:         true,
    feedback_submitted:false
  )

  # S7
  session_attendees << SessionAttendee.create!(
    tutor_session:     s7,
    learner:           lucas,
    attended:          true,
    cancelled:         false,
    feedback_submitted:true
  )
  session_attendees << SessionAttendee.create!(
    tutor_session:     s7,
    learner:           charlotte,
    attended:          true,
    cancelled:         false,
    feedback_submitted:true
  )

  # S8
  session_attendees << SessionAttendee.create!(
    tutor_session:     s8,
    learner:           henry,
    attended:          true,
    cancelled:         false,
    feedback_submitted:true
  )
  session_attendees << SessionAttendee.create!(
    tutor_session:     s8,
    learner:           amelia,
    attended:          true,
    cancelled:         false,
    feedback_submitted:true
  )

  # S9
  session_attendees << SessionAttendee.create!(
    tutor_session:     s9,
    learner:           alexander,
    attended:          false,
    cancelled:         false,
    feedback_submitted:false
  )

  # S10
  session_attendees << SessionAttendee.create!(
    tutor_session:     s10,
    learner:           harper,
    attended:          true,
    cancelled:         false,
    feedback_submitted:true
  )
  session_attendees << SessionAttendee.create!(
    tutor_session:     s10,
    learner:           daniel,
    attended:          false,
    cancelled:         false,
    feedback_submitted:false
  )
  session_attendees << SessionAttendee.create!(
    tutor_session:     s10,
    learner:           evelyn,
    attended:          true,
    cancelled:         false,
    feedback_submitted:false
  )

  # S11
  session_attendees << SessionAttendee.create!(
    tutor_session:     s11,
    learner:           michael,
    attended:          false,
    cancelled:         false,
    feedback_submitted:false
  )

  # Feedbacks (11)
  puts "Creating feedback..."

  feedbacks = []

  feedbacks << Feedback.create!(
    tutor_session: s1,
    learner:       michael,
    tutor:         tutor_anna,
    rating:        5,
    comment:       "Great explanations of limits and continuity."
  )
  feedbacks << Feedback.create!(
    tutor_session: s1,
    learner:       liam,
    tutor:         tutor_anna,
    rating:        4,
    comment:       "Helpful derivative review with clear examples."
  )
  feedbacks << Feedback.create!(
    tutor_session: s1,
    learner:       olivia,
    tutor:         tutor_anna,
    rating:        5,
    comment:       "Very patient and answered every question."
  )

  feedbacks << Feedback.create!(
    tutor_session: s4,
    learner:       james,
    tutor:         tutor_brian,
    rating:        4,
    comment:       "Good pace and solid explanation of linked lists."
  )

  feedbacks << Feedback.create!(
    tutor_session: s7,
    learner:       lucas,
    tutor:         tutor_claire,
    rating:        5,
    comment:       "Confidence intervals finally make sense now."
  )
  feedbacks << Feedback.create!(
    tutor_session: s7,
    learner:       charlotte,
    tutor:         tutor_claire,
    rating:        4,
    comment:       "Nice mix of theory and practice problems."
  )

  feedbacks << Feedback.create!(
    tutor_session: s8,
    learner:       henry,
    tutor:         tutor_claire,
    rating:        5,
    comment:       "Clear diagrams for supply and demand shifts."
  )

  feedbacks << Feedback.create!(
    tutor_session: s10,
    learner:       harper,
    tutor:         tutor_david,
    rating:        5,
    comment:       "Worked through multiple Newton's laws examples step by step."
  )

  feedbacks << Feedback.create!(
    tutor_session: s1,
    learner:       noah,
    tutor:         tutor_anna,
    rating:        4,
    comment:       "Good review but we ran out of time for some questions."
  )
  feedbacks << Feedback.create!(
    tutor_session: s8,
    learner:       amelia,
    tutor:         tutor_claire,
    rating:        4,
    comment:       "Helped me understand elasticity better before the quiz."
  )

  puts "Seed data created:"
  puts "  Admins:             #{Admin.count}"
  puts "  Learners:           #{Learner.count}"
  puts "  Subjects:           #{Subject.count}"
  puts "  Tutor applications: #{TutorApplication.count}"
  puts "  Tutors:             #{Tutor.count}"
  puts "  Teaches:            #{Teach.count}"
  puts "  Tutor sessions:     #{TutorSession.count}"
  puts "  Session attendees:  #{SessionAttendee.count}"
  puts "  Feedbacks:          #{Feedback.count}"
end