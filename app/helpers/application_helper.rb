# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def lighthouse_auto_link(project, text)
    result = auto_link(text)
    return result if project.nil?

    prefix = "http://#{project.user.subdomain}.lighthouseapp.com/projects/#{project.lighthouse_id}/tickets/"
    result.gsub(/#([0-9]+)/, "<a href=\"#{prefix}\\1\">#\\1</a>")
  end
end
