class AddTreatObjToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :treat_obj, :text
  end
end
