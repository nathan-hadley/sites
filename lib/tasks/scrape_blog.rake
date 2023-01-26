require "open-uri"
require "nokogiri"

# Execute bundle exec rake scrape_blog
task scrape_blog: :environment do
  # Scrape the blog page
  url = ""
  @num = 1

  loop do
    doc = Nokogiri::HTML(URI.open(url))

    # Find all article elements on the page
    articles = doc.css("article")

    articles.each do |article|

      header_image = ""

      # Find the header image and caption
      special_content = article.css("div.special-content")
      img = special_content.css("img")
      img_url = img.first["src"]

      download_image(img_url)
      header_image += "<figure class='header-img'>"
      header_image += "<img src='/assets/#{File.basename(img_url).gsub(".jpeg", "-#{@num}.jpeg")}' alt='#{File.basename(img_url).gsub(".jpeg", "-#{@num}.jpeg")}'/>"
      @num += 1
      caption = special_content.css('div.image-caption').css("p").text
      header_image += "<p>#{caption}</p>" if caption.present?
      header_image += "</figure>"

      # Get the title and publish date
      title = article.css("h1").text.strip
      publish_date = article.css("time")[0]["datetime"].strip.to_datetime

      # Just look at article body for everything else
      body = article.css("div.body")

      # Initialize the content as an empty string
      content = ""

      # Loop through the main elements of the article (p, a, img tags)
      body.css("p, h2, h3, h4, h5, br, figure").each do |element|
        # If the element is an image, download it and replace the src with the local file path
        case element.name
        when "figure"
          img = element.css("img")
          img_url = img.first["src"]
          next if img_url.nil?

          download_image(img_url)
          caption = element.css("div.image-caption").css("p").text
          content += "<figure><img src='/assets/#{File.basename(img_url).gsub(".jpeg", "-#{@num}.jpeg")}' alt='#{File.basename(img_url).gsub(".jpeg", "-#{@num}.jpeg")}'/>"
          @num += 1
          content += "<p>#{caption}</p>" if caption.present?
          content += "</figure>"
        else
          # Add the element to the content as HTML
          content += clean_html(element.to_html) unless element.ancestors("div.image-caption").any?
        end
      end

      article = Article.find_by(title: title)
      if article.present?
        article.update(title: title, header_image_html: header_image,
                       content_html: content, publish_date: publish_date)
      else
        Article.create(title: title, header_image_html: header_image,
                       content_html: content, publish_date: publish_date)
      end
      puts "scraped #{title}"
    end

    # Check for the next page link
    next_page = doc.css(".pagination a:contains('Next')")

    # If there is no next page link, break out of the loop
    break if next_page.empty?

    # Otherwise, update the URL to the next page
    url = "https://nathanhadley.com#{next_page[0]['href']}"
  end
end

def download_image(img_url)
  image_path = "app/assets/images/"
  img_data = URI.open(img_url).read
  File.open("#{image_path}#{File.basename(img_url).gsub(".jpeg", "-#{@num}.jpeg")}", "wb") do |f|
    f.write(img_data)
  end
end

def clean_html(html_string)
  html_string.gsub!(/class=".*?"|style=".*?"|target=".*?"/, "") # Remove class and style elements
  html_string = html_string.gsub(/<\s+/, "<").gsub(/\s+>/, ">") # Clean whitespace within tags
  html_string.gsub('data-rte-preserve-empty="true"', "")
end
