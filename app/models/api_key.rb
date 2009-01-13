class ApiKey < ActiveRecord::Base
  belongs_to :user
  has_many :projects

  def lighthouse
    @api ||= MultiLighthouse.new(subdomain, token)
  end
end
