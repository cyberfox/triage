module TicketsHelper
  def get_first_body(project_id, ticket_number)
    versions = current_user.projects.find_by_lighthouse_id(project_id).tickets.find_by_number(ticket_number).lighthouse.versions
    if versions
      if versions.first.respond_to? :body
        versions.first.body
      else
        versions.first['body']
      end
    else
      ""
    end
  end
end
