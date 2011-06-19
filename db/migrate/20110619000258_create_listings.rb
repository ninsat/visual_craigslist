class CreateListings < ActiveRecord::Migration
  def self.up
    create_table :listings do |t|
      t.string :url
      t.string :neighborhood
      t.string :location
      t.string :title
      t.text :body
      t.integer :price

      t.timestamps
    end
  end

  def self.down
    drop_table :listings
  end
end
