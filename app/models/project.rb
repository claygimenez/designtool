class Project < ActiveRecord::Base
  belongs_to :user

  def self.recent
    order('created_at DESC')
  end
end
