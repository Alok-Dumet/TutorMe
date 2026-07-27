class CreateTutorApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :tutor_applications do |t|
      t.references :learner, null: false, foreign_key: true
      t.string :reason
      t.string :status

      t.timestamps
    end
  end
end
