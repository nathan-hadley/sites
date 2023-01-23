require 'open-uri'
require 'nokogiri'

# Execute bundle exec rake scrape_blog
task :scrape_blog do
  # Scrape the blog page
  url = 'https://nathanhadley.com/'

  loop do
    doc = Nokogiri::HTML(URI.open(url))

    # Find all article elements on the page
    articles = doc.css('article')

    articles.each do |article|

      header_image = ''

      # Find the header image and caption
      special_content = article.css('div.special-content')
      special_content.css('img, div.image-caption').each do |element|
        if element.name == 'img'
          img_url = element['src']
          next if img_url.nil?

          #download_image(img_url)
          header_image += "<%= image_tag '#{File.basename(img_url)}'%>"
        else
          # Remove the div element
          caption = element.at_css('p').text
          header_image += "<p class='image-caption'>#{caption}</p>"
        end
      end

      # Get the title and created_at date
      title = article.css('h1').text.strip
      created_at = article.css('time')[0]['datetime'].strip

      # Just look at article body for everything else
      body = article.css('div.body')

      # Initialize the content as an empty string
      content = ''

      # Initialize image captions to prevent adding duplicates
      image_caption_text = ''

      # Loop through the main elements of the article (p, a, img tags)
      body.css('p, br, img, div.image-caption').each do |element|
        # If the element is an image, download it and replace the src with the local file path
        case element.name
        when 'img'
          img_url = element['src']
          next if img_url.nil?

          #download_image(img_url)
          content += "<%= image_tag '#{File.basename(img_url)}'%>"
          next
        when 'div'
          if element['class'] == 'image-caption'
            # Get the text of the caption
            image_caption_text = element.css('p').text
            content += "<p class='image-caption'>#{image_caption_text}</p>"
          end
        when 'br'
          content += clean_html(element.to_html)
        else
          # Don't add empty p tags
          next if element.text.blank?

          # Add the element to the content as HTML
          content += clean_html(element.to_html) unless element.text.include?(image_caption_text)
        end
      end

      # Save the article to the "Article" table in your Rails site
      # article = Article.create(title: title, content: content, created_at: created_at)

      puts '<---HEADER IMAGE--->'
      puts header_image
      puts '<---TITLE--->'
      puts title
      puts '<---CREATED AT--->'
      puts created_at
      puts '<---CONTENT--->'
      puts content
    end

    # Check for the next page link
    next_page = doc.css(".pagination a:contains('Next')")

    # If there is no next page link, break out of the loop
    break if next_page.empty?

    # Otherwise, update the URL to the next page
    url = "https://nathanhadley.com#{next_page[0]['href']}"
    puts url
  end
end

def download_image(img_url)
  image_path = 'app/assets/images/'
  img_data = URI.open(img_url).read
  File.open("#{image_path}#{File.basename(img_url)}", 'wb') do |f|
    f.write(img_data)
  end
end

def clean_html(html_string)
  html_string.gsub!(/class=".*?"|style=".*?"|target=".*?"/, '') # Remove class and style elements
  html_string = html_string.gsub(/<\s+/, '<').gsub(/\s+>/, '>') # Clean whitespace within tags
  html_string.gsub('data-rte-preserve-empty="true"', '')
end
