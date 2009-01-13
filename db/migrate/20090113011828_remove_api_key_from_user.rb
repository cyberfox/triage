class RemoveApiKeyFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :api_key
    remove_column :users, :subdomain
  end

  def self.down
    add_column :users, :api_key, :string
    add_column :users, :subdomain, :string
  end
end
