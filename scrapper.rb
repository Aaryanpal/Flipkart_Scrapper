require 'open-uri'
require 'csv'
require 'byebug'
class Scrapper

    def initialize(url)
        @product_count
        @url = url
    end
    def action
        request = open(@url)
        resp = request.read
        identifier = '_4rR01T'

        found_indexes = []
        current_index = 0
=begin
For Finding The indexes of Each similar Div That Hold The Product Name
=end
        while current_index!= nil
            current_index = resp[(current_index + 1)..-1].index(identifier)
            if current_index!=nil
                current_index=current_index+1
                if found_indexes.any?
                    current_index = found_indexes.last + current_index
                end
                found_indexes << current_index
            end
        end
=begin
For Pushing The Name Of the product in an array
=end
        phones = []
        count = 0
        while(count< found_indexes.count)
               res =  resp[ (found_indexes[count] + identifier.length + 2)..(found_indexes[count] + 37 )]
               
               if res!=nil
                phones << res
            end
            count = count + 1; 
        end

=begin
For Getting THe Result from Other Pages
=end
        page = 2
        next_page_url = @url+"&page=#{page}"
        req2 = open(next_page_url)
        resp2 = req2.read

        current_index = 0
        while current_index!= nil
            current_index = resp[(current_index + 1)..-1].index(identifier)
            if current_index!=nil
                current_index=current_index+1
                if found_indexes.any?
                    current_index = found_indexes.last + current_index
                end
                found_indexes << current_index
            end
        end

        count = 0
        while(count< found_indexes.count)
               res =  resp[ (found_indexes[count] + identifier.length + 2)..(found_indexes[count] + 37 )]
               
               if res!=nil
                phones << res
            end
            count = count + 1; 
        end

        page = 3
        next_page_url = @url+"&page=#{page}"
        req2 = open(next_page_url)
        resp2 = req2.read

        current_index = 0
        while current_index!= nil
            current_index = resp[(current_index + 1)..-1].index(identifier)
            if current_index!=nil
                current_index=current_index+1
                if found_indexes.any?
                    current_index = found_indexes.last + current_index
                end
                found_indexes << current_index
            end
        end

        count = 0
        while(count< found_indexes.count)
               res =  resp[ (found_indexes[count] + identifier.length + 2)..(found_indexes[count] + 37 )]
               
               if res!=nil
                phones << res
            end
            count = count + 1; 
        end

=begin
For Writing The CSV REsult
=end
        CSV.open('result.csv','wb') do |csv|
            csv << ["S.no","Phone "]
           phones.each_with_index do |row,index|
            csv << [index]
            csv << [row]
            
        end
    end
    byebug
        puts "Total Product: #{phones.count}"
    end
    # def find_indexes
        
    # end
end

url = 'https://www.flipkart.com/search?q=smart%20phones&otracker=search&otracker1=search&mark
etplace=FLIPKART&as-show=on&as=off'
obj = Scrapper.new(url)
obj.action