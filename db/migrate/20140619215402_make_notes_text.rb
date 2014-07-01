class MakeNotesText < ActiveRecord::Migration
  def up
    change_column :notes, :text, :text
  end

  def down
    change_column :notes, :text, :string
  end
end
