class ProjectSerializer < ActiveModel::Serializer
  attributes :title, :notes, :reflections, :tfidf, :clusters, :dom_id, :id

  def dom_id
    dom_id_manager.dom_id object
  end

  def reflections
    object.reflect
  end

  def tfidf
    # object.kmeans(object.tfidf_matrix(object.term_list))
  end

  def clusters
    object.clusters
  end

  private

  def dom_id_manager
    @dom_id_manager ||= Class.new do
      include ActionController::RecordIdentifier
    end.new
  end
end
