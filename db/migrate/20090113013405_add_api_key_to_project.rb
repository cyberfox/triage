class AddApiKeyToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :api_key_id, :integer
  end

  def self.down
    remove_column :projects, :api_key_id
  end
end
