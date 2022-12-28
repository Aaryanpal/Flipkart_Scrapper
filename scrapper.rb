require 'open-uri'
require 'nokogiri'
require 'byebug'
class Scrapper

    def initialize(url)
        @product_count
        @url = url
    end
    def action
        request = open(@url)
        resp = request.read
        # response = Nokogiri::HTML(URI.open(@url))
        byebug
        identifier = '_4rR01T'
        sol = resp.scan(identifier)
        puts "Total Product: #{sol.count}"
    end
end

url = 'https://www.flipkart.com/search?q=smart%20phones&otracker=search&otracker1=search&mark
etplace=FLIPKART&as-show=on&as=off'
obj = Scrapper.new(url)
obj.action