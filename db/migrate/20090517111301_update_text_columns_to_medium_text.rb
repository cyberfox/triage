class UpdateTextColumnsToMediumText < ActiveRecord::Migration
  def self.up
#    execute "ALTER TABLE tickets MODIFY data MEDIUMTEXT"
  end

  def self.down
#    execute "ALTER TABLE tickets MODIFY data TEXT"
  end
end
