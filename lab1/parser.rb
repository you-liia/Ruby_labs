require 'csv'
require 'mechanize'

require_relative 'prod'


class Parser

  BASE_URL = "https://acc.cv.ua/news/chernivtsi/"


  attr_accessor :max_pages, :start_page, :items

  def initialize(start_page, max_pages)
    @max_pages  = max_pages
    @start_page = start_page
    @agent      = Mechanize.new
    @items      = []
  end

  

def parse_item(item)

    date = item.at('div.AllNewsItemService__date')

    comments = item.at('span.disqus-comment-count')

    title = item.at('a.AllNewsItemInfo__name')

    text = item.at('a.AllNewsItemInfo__desc')                     


    Prod.new(date, comments, title, text)
  end



  def parse_curr_page
    @items += @curr_page.search('div.blog-item.AllNewsItem').map { |item| parse_item(item) rescue error puts error }          
    self
  end

  def next_page
    next_page_link = @curr_page.at('li.endLi')                                                             
    @curr_page     = @agent.click(next_page_link)
  end

  def parse
    @curr_page     = @agent.get(BASE_URL % @start_page)
    @items         = []
    pages_to_parse = @max_pages - @start_page + 1
    pages_to_parse.times do |curr_page_number|
      puts "Parsing page #{curr_page_number + @start_page}"
      parse_curr_page
      next_page
      puts @curr_page.uri.to_s
    end
    @items.compact!
    self
  end

  def to_json(file_path)
    File.write(file_path, JSON.pretty_generate(@items))
    self
  end

  def to_csv(file_path)
    csv_result = CSV.generate do |csv|
      csv << @items.first.instance_variables.map {|variable_name| variable_name[1..-1]}
      @items.each { |item| csv << item.values }
    end
    File.write(file_path, csv_result)
    self
  end

end
