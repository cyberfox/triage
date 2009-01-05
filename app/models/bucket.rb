class Bucket < ActiveRecord::Base
  belongs_to :user
  belongs_to :milestone

  validates_presence_of :user_id, :tag

  def apply(ticket)
  end
end
