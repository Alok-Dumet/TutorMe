class AddArchivedToSubjects < ActiveRecord::Migration[8.0]
  def change
    add_column :subjects, :archived, :boolean, null: false, default: false
    add_index  :subjects, :archived
  end
end
