class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :text
      t.integer :project_id

      t.timestamps
    end
  end
end
