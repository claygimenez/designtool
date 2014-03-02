class ProjectSerializer < ActiveModel::Serializer
  attributes :title, :notes, :dom_id, :id

  def dom_id
    dom_id_manager.dom_id object
  end

  private

  def dom_id_manager
    @dom_id_manager ||= Class.new do
      include ActionController::RecordIdentifier
    end.new
  end
end
