class CreateLighthouseUsers < ActiveRecord::Migration
  def self.up
    create_table :lighthouse_users do |t|
      t.string :name
      t.integer :lighthouse_id
      t.string :website
      t.string :job

      t.timestamps
    end
  end

  def self.down
    drop_table :lighthouse_users
  end
end
