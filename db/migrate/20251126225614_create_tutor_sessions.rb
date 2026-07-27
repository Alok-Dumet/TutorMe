class CreateTutorSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :tutor_sessions do |t|
      t.references :tutor, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at
      t.integer :capacity
      t.string :status
      t.string :meeting_link

      t.timestamps
    end
  end
end
