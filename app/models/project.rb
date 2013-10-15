class Project < ActiveRecord::Base
  belongs_to :user
  has_many :notes

  def self.recent
    order('created_at DESC')
  end
end
