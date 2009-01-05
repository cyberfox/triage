class Bucket < ActiveRecord::Base
  belongs_to :user
  has_one :milestone

  validates_presence_of :user_id, :tag
end
