class AddMilestoneToBucket < ActiveRecord::Migration
  def self.up
    add_column :buckets, :milestone_id, :integer
  end

  def self.down
    remove_column :buckets, :milestone_id
  end
end
