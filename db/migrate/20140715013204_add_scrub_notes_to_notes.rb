class AddScrubNotesToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :scrubbed_notes, :text
  end
end
