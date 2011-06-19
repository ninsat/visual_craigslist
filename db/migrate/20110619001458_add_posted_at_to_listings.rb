class AddPostedAtToListings < ActiveRecord::Migration
  def self.up
    add_column :listings, :posted_at, :date
  end

  def self.down
    remove_column :listings, :posted_at
  end
end
