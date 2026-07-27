# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_12_06_102917) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.bigint "tutor_session_id", null: false
    t.bigint "learner_id", null: false
    t.bigint "tutor_id", null: false
    t.integer "rating", null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["learner_id"], name: "index_feedbacks_on_learner_id"
    t.index ["tutor_id"], name: "index_feedbacks_on_tutor_id"
    t.index ["tutor_session_id", "learner_id"], name: "index_feedbacks_on_tutor_session_id_and_learner_id", unique: true
    t.index ["tutor_session_id"], name: "index_feedbacks_on_tutor_session_id"
  end

  create_table "learners", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "session_attendees", force: :cascade do |t|
    t.bigint "tutor_session_id", null: false
    t.bigint "learner_id", null: false
    t.boolean "attended"
    t.boolean "feedback_submitted", default: false
    t.boolean "cancelled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["learner_id"], name: "index_session_attendees_on_learner_id"
    t.index ["tutor_session_id"], name: "index_session_attendees_on_tutor_session_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "archived", default: false, null: false
    t.index ["archived"], name: "index_subjects_on_archived"
  end

  create_table "teaches", force: :cascade do |t|
    t.bigint "tutor_id", null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_teaches_on_subject_id"
    t.index ["tutor_id"], name: "index_teaches_on_tutor_id"
  end

  create_table "tutor_applications", force: :cascade do |t|
    t.bigint "learner_id", null: false
    t.string "reason"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["learner_id"], name: "index_tutor_applications_on_learner_id"
  end

  create_table "tutor_sessions", force: :cascade do |t|
    t.bigint "tutor_id", null: false
    t.bigint "subject_id", null: false
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer "capacity"
    t.string "status"
    t.string "meeting_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_tutor_sessions_on_subject_id"
    t.index ["tutor_id"], name: "index_tutor_sessions_on_tutor_id"
  end

  create_table "tutors", force: :cascade do |t|
    t.text "bio"
    t.bigint "learner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["learner_id"], name: "index_tutors_on_learner_id"
  end

  add_foreign_key "feedbacks", "learners"
  add_foreign_key "feedbacks", "tutor_sessions"
  add_foreign_key "feedbacks", "tutors"
  add_foreign_key "session_attendees", "learners"
  add_foreign_key "session_attendees", "tutor_sessions"
  add_foreign_key "teaches", "subjects"
  add_foreign_key "teaches", "tutors"
  add_foreign_key "tutor_applications", "learners"
  add_foreign_key "tutor_sessions", "subjects"
  add_foreign_key "tutor_sessions", "tutors"
  add_foreign_key "tutors", "learners"
end
