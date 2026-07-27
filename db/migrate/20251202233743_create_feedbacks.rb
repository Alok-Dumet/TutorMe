class CreateFeedbacks < ActiveRecord::Migration[8.0]
  def change
    create_table :feedbacks do |t|
      t.references :tutor_session, null: false, foreign_key: true
      t.references :learner, null: false, foreign_key: true
      t.references :tutor, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :comment

      t.timestamps
    end

    add_index :feedbacks, [:tutor_session_id, :learner_id], unique: true
  end
end
