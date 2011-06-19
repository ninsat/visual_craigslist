class Listing < ActiveRecord::Base
  validates_presence_of :url

  has_many :image_urls
end
