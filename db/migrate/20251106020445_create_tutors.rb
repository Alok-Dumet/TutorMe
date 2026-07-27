class CreateTutors < ActiveRecord::Migration[8.0]
  def change
    create_table :tutors do |t|
      t.text :bio
      t.references :learner, null: false, foreign_key: true

      t.timestamps
    end
  end
end