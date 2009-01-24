# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def button_to_remote(name, options = {}, html_options = {})
    button_to(name, options, html_options.merge(:onclick => remote_function(options.merge(:url => options))+"; return false" ))
  end
end
