require 'test_helper'
require 'ostruct'

class TicketTest < ActiveSupport::TestCase
  context "Search" do
    should "return tickets" do
      tickets = Ticket.search(projects(:jbidwatcher), "order:number", 1)
      assert !tickets.empty?
      assert_equal 30, tickets.length
    end
  end

  test "Find by P & T fills in details if latest_update newer than DB ticket" do
    original = tickets(:snipe_error)
    assert_equal "empty", original.data
    ticket = Ticket.find_by_project_and_ticket(projects(:jbidwatcher), 254, Time.now)
    original.reload
    assert_not_equal "empty", original.data
    decoded = YAML.load(original.data)
    assert_equal ticket, decoded
  end

  test "Find by P & T on outdated ticket updates it" do
    original = tickets(:out_of_date_snipe_error)
    # Just making it clear the updated_at was a while ago.
    assert original.updated_at < 10.minutes.ago

    ticket = Ticket.find_by_project_and_ticket(projects(:out_of_date), 254)

    original.reload
    assert original.updated_at > 2.seconds.ago
  end

  test "Find by P & T on up-to-date ticket doesn't update it" do
    original = tickets(:up_to_date_snipe_error)
    # Just making it clear the updated_at was a while ago.
    assert original.updated_at < 10.minutes.ago
    # But not too long ago...
    assert original.updated_at > 1.day.ago

    assert_no_difference("tickets(:up_to_date_snipe_error).reload.updated_at") do
      ticket = Ticket.find_by_project_and_ticket(projects(:current), 254)
    end
  end

  test "Import all tickets" do
    assert_difference('Ticket.count', 28) do
      Ticket.import_all(projects(:jbidwatcher))
    end
  end
end
