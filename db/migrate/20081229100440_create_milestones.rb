class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.integer :project_id
      t.string :title
      t.text :data

      t.timestamps
    end
  end

  def self.down
    drop_table :milestones
  end
end
