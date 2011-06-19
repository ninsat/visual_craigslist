class CreateImageUrls < ActiveRecord::Migration
  def self.up
    create_table :image_urls do |t|
      t.integer :listing_id
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :image_urls
  end
end
