require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  context "lighthouse auto_link" do
    should "return an empty string for an empty string" do
      assert_equal '', lighthouse_auto_link(nil, '')
    end

    should "auto_link normally a basic string" do
      basic_message = "Applied mrs@best.com 'featurerequest' to http://url.com 'Selling tab empty with 2.0beta8 [OS X 10.5.4]'."
      assert_equal "Applied <a href=\"mailto:mrs@best.com\">mrs@best.com</a> 'featurerequest' to <a href=\"http://url.com\">http://url.com</a> 'Selling tab empty with 2.0beta8 [OS X 10.5.4]'.",
        lighthouse_auto_link(nil, basic_message)
    end

    should "not auto_link a ticket number when no project is given" do
      basic_message = "Applied mrs@best.com 'featurerequest' to http://url.com 'Selling tab empty with 2.0beta8 [OS X 10.5.4]' (ticket #999)."
      assert_equal "Applied <a href=\"mailto:mrs@best.com\">mrs@best.com</a> 'featurerequest' to <a href=\"http://url.com\">http://url.com</a> 'Selling tab empty with 2.0beta8 [OS X 10.5.4]' (ticket #999).",
        lighthouse_auto_link(nil, basic_message)
    end

    should "auto_link a ticket number to the lighthouse page when a project is given" do
      basic_message = "Applied mrs@best.com 'featurerequest' to http://url.com 'Selling tab empty with 2.0beta8 [OS X 10.5.4]' (ticket #999)."
      assert_equal "Applied <a href=\"mailto:mrs@best.com\">mrs@best.com</a> 'featurerequest' to <a href=\"http://url.com\">http://url.com</a> 'Selling tab empty with 2.0beta8 [OS X 10.5.4]' (ticket <a href=\"bar.lighthouseapp.com/projects/8037/tickets/999\">#999</a>).",
        lighthouse_auto_link(projects(:jbidwatcher), basic_message)
    end
  end
end
