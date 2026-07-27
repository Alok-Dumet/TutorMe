class CreateTeaches < ActiveRecord::Migration[8.0]
  def change
    create_table :teaches do |t|
      t.references :tutor, null: false, foreign_key: true
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end
  end
end
