class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.integer :project_id
      t.string :query
      t.string :name
      t.text :data

      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end
end
