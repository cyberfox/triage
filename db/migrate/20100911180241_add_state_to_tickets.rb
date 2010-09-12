class AddStateToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :state, :string
    add_column :tickets, :closed, :boolean
  end

  def self.down
    remove_column :tickets, :state
    remove_column :tickets, :closed
  end
end
