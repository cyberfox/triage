class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer :project_id
      t.integer :number
      t.string :title
      t.text :data

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
