require 'open-uri'
require 'csv'
require 'byebug'
require 'sidekiq'
require 'sidekiq-cron'

class Scrapper
=begin
Scrapping The Flipkart Website
WElcome Banner Message
-> Asked For the User name
-> Asked for the Categories we are dealing With(1. Phones, 2.Books 3. Shoes)
-> Show them the Default URL for the Choosen Categories
-> Show THem For the Default CSS Class For PRoduct Name and Price
-> Give Prompt For Updating The CSS Class
-> ASked For HOw many page Resut they want To scrap
-> EndTHe Function By showing them the Greating Message directory were CSV is save and The Name Of The CSV
=end
    # attr_accessor :name, :option,:page
    def initialize(url)
        # puts "***************Welcome To Flipkart Scrapper***********"
        @url = url
        puts "How Many Pages of Data u want Choose b/w(1-10)"
        @page = gets.chomp.to_i
    end

    def display
        puts "\t\t\t\t\t*************** Welcome To Flipkart Scrapper ***********"
        puts "Kindly Enter Your Good Name"
        @name = gets.chomp
        puts "Hi, #{name} welcome to our store"
        puts "We are Dealing in These Categories Kindly choose"
        puts "1. Phones \n2. Books \n3. Sneakers"
        @option = gets.chomp
        puts "How Many Pages of Data u want Choose b/w(1-10)"
        @page = gets.chomp
    end

    def find_indexes
        count = 1
        @identifier_name = '<div class="_4rR01T">'
        @identifier_price = '<div class="_30jeq3 _1_WHN1">'
        @found_indexes_price = []
        @found_indexes_name = []
        while(count <= @page)
            request = URI.open(@url)
            @resp = request.read
            current_index_i = 0
            current_index_j = 0
            while current_index_i!= nil && current_index_j!=nil
                current_index_i = @resp[(current_index_i + 1)..-1].index(@identifier_name)
                current_index_j = @resp[(current_index_j + 1)..-1].index(@identifier_price)
                if current_index_i!=nil && current_index_j!=nil
                    current_index_i=current_index_i+1
                    current_index_j=current_index_j+1
                    if @found_indexes_name.any?
                        current_index_i = @found_indexes_name.last + current_index_i
                    end
                    if @found_indexes_price.any?
                        current_index_j = @found_indexes_price.last + current_index_j
                    end
                    @found_indexes_name << current_index_i
                    @found_indexes_price << current_index_j
                    
                end
            end
            puts "SCRAP THE #{count} PAGE"
            count = count + 1
            @url = @url+"&page=#{count}"
        end
        byebug
    end

    def find_product
        @product = []
        @product_price = []

        count = 0
        while(count< @found_indexes_name.count)
               res =  @resp[ (@found_indexes_name[count] + @identifier_name.length)..(@found_indexes_name[count] + 37 )]
               res_2 = @resp[ (@found_indexes_price[count] + @identifier_price.length)..(@found_indexes_price[count]+ @identifier_price.length + 6 )]
               if res!=nil && res_2!=nil
                @product << res
                @product_price << res_2
            end
            count = count + 1; 
        end
        puts "Total Count Product: #{@product.count}"
    end
    def import_csv
        CSV.open('result.csv','wb') do |csv|
            csv << ["S.no","Phone ", "Price"]
            @product.each_with_index do |row,index|
            csv << [index,row,@product_price[index]]
            end
        end
        puts "Your CSV is Ready Visit Again For Updated Data"
    end

    def action
        request = URI.open(@url)
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
        puts "ALL THE INDEXES"
        found_indexes.each {|n| puts n}
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
        req2 = URI.open(next_page_url)
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
        req2 = URI.open(next_page_url)
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
            csv << [index,row]
        end
    end
        puts "Total Product: #{phones.count}"
    end
end

url = 'https://www.flipkart.com/search?q=smart%20phones&otracker=search&otracker1=search&marketplace=FLIPKART&as-show=on&as=off'

obj = Scrapper.new(url)
obj.find_indexes
obj.find_product
obj.import_csv

Sidekiq::Cron::Job.create(name: 'Scrapper - every 5min', cron: '*/5 * * * *', class: 'Scrapper') # execute at every 5 minutes

# obj.action