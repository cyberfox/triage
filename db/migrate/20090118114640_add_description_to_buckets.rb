class AddDescriptionToBuckets < ActiveRecord::Migration
  def self.up
    add_column :buckets, :description, :string
  end

  def self.down
    remove_column :buckets, :description
  end
end
