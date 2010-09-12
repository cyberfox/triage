class Bucket < ActiveRecord::Base
  belongs_to :user
  belongs_to :milestone

  validates_presence_of :user_id, :tag

  def apply_one(ticket)
    lh_ticket = Ticket.retrieve(ticket.project, ticket.number)
    lh_ticket.milestone_id = milestone.lighthouse_id if milestone
    lh_ticket.state = state if state
    lh_ticket.body = boilerplate if boilerplate
    lh_ticket.tags << tag
    lh_ticket.save
    ticket.update_attribute :data, lh_ticket.to_xml
  end
end
