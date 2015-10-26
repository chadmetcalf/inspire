class Scrape
  require 'open-uri'
  
  def initialize(subreddit_name)
    @subreddit_name = subreddit_name
  end

  def post
    Poster.new(text: subreddit_text, image: flickr_image)
  end
  
  def reddit_textpage
    @reddit_textpage ||= Nokogiri::HTML(open(reddit_uri))
  end
  
  def flickr_imagepage
    @flickr_imagepage ||= Nokogiri::HTML(open('https://www.flickr.com/explore/interesting/7days/'))
  end

  private
  
  def subreddit_link
    @subreddit_link ||= subreddit_links.sample.css('a.title')
  end

  def subreddit_links
    reddit_textpage.css('div.link')
  end
  
  def subreddit_text
    subreddit_link.text
  end

  # Unused method?
  def subreddit_link_url
    subreddit_link.css('a.comments').map { |link| link['href'] }.first
  end

  def flickr_imagelink_url
    "https://www.flickr.com#{flickr_imagepage.at_css("td.Owner a")['href']}"
  end

  def flickr_image
    @flickr_image || flickr_image!
  end
  
  def flickr_image!
    Nokogiri::HTML(open(flickr_imagelink_url)).at_css("img.main-photo")['src']
    @flickr_image = "http:#{image}"
  end
  
  def reddit_uri
    return "https://www.reddit.com/" if @subreddit_name.blank?

    "https://www.reddit.com/r/#{@subreddit_name}"
  end
end
