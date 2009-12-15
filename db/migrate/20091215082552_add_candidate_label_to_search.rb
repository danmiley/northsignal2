class AddCandidateLabelToSearch < ActiveRecord::Migration
  def self.up
    add_column :searches, :candidate_label, :string
  end

  def self.down
    remove_column :searches, :candidate_label
  end
end
