class CreateLearners < ActiveRecord::Migration[8.0]
  def change
    create_table :learners do |t|
      t.string :email,           null: false
      t.string :password_digest, null: false
      t.string :first_name
      t.string :last_name
      t.timestamps
    end
  end
end
