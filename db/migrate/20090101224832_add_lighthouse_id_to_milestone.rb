class AddLighthouseIdToMilestone < ActiveRecord::Migration
  def self.up
    add_column :milestones, :lighthouse_id, :integer
  end

  def self.down
    remove_column :milestones, :lighthouse_id
  end
end
