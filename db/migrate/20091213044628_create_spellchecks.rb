class CreateSpellchecks < ActiveRecord::Migration
  def self.up
    create_table :spellchecks do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :spellchecks
  end
end
