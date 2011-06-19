require 'open-uri'
class CraigslistSearch

  attr_accessor :text
  attr_accessor :min
  attr_accessor :max
  attr_accessor :bedrooms

  def self.query(options)
    new(options).search
  end


  def initialize(options)
    @text = options[:text]
    @min, @max = options[:min], options[:max]
    @bedrooms = options[:bedrooms]
  end

  def search
    fetch_listings(listing_urls)
  end

  private

  def listing_urls
    [].tap do |urls|

      moar = true
      start = 0

      while moar do
        doc = Nokogiri::HTML(open(query_url(start)))
        urls << listings(doc)
        start += 100
        next_button = doc.css('span a').detect { |e| e.text =~ /Next/ } 
        moar = false unless next_button
      end

    end.flatten
  end

  def query_url(start)
    base = 'http://boston.craigslist.org/search/sub/gbs?'
    base + "query=#{text}&srchType=A&minAsk=#{min}&maxAsk=#{max}&bedrooms=#{bedrooms}&hasPic=1&s=#{start}"
  end

  def listings(doc)
    doc.css('p').map do |listing|
      listing.css('a').first.attr(:href)
    end
  end

  def fetch_listings(urls)
    urls.each do |url|
      store(Nokogiri::HTML(open(url)), url)
    end
  end

  def store(doc, url)
    price, title, neighborhood = doc.css('h2').text.scan(/^\$(\d+)(.*)\((.*)\)$/).first

    listing = Listing.new(:price => price, :title => title, :neighborhood => neighborhood) do |l|
      l.posted_at = Date.parse(doc.text.scan(/Date: (\d{4}-\d{2}-\d{2})/).first.first)
      l.url = url
      l.body = doc.css('div#userbody').text # TODO: xss?
      # l.location #TODO
    end


    listing.save!
    puts listing.id

    doc.css('img').each do |img|
      listing.image_urls.create!(:url => img.attr(:src))
    end

  end


end

