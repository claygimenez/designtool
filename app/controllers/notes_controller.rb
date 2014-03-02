class NotesController < ApplicationController
  respond_to :html, :json

  def create
    @note = Note.new(note_params)
    @note.save
    render json: @note
  end

  def index
    @notes = Note.all
  end

  private

  def note_params
    params.require(:note).permit(:text, :project_id)
  end
end
