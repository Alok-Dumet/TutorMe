class CreateSubjects < ActiveRecord::Migration[8.0]
  def change
    create_table :subjects do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.text :description

      t.timestamps
    end
  end
end
