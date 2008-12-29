class CreateSearchResults < ActiveRecord::Migration
  def self.up
    create_table :search_results do |t|
      t.integer :search_id
      t.integer :ticket_number
      t.string :title
      t.text :data

      t.timestamps
    end
  end

  def self.down
    drop_table :search_results
  end
end
