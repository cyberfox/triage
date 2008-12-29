class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.integer :lighthouse_id
      t.integer :user_id
      t.string :name
      t.text :data

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
