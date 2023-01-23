require 'open-uri'
require 'nokogiri'

# Execute bundle exec rake scrape_blog
task :scrape_blog do
  # Scrape the blog page
  url = 'https://nathanhadley.com/'
  image_path = 'app/assets/images/'
  doc = Nokogiri::HTML(URI.open(url))

  # Find all article elements on the page
  articles = doc.css("article")

  articles.each do |article|
    # Get the title and created_at date
    title = article.css("h1").text
    created_at = article.css("time")[0]["datetime"]

    # Initialize the content as an empty string
    content = ""

    # Loop through the main elements of the article (p, a, img tags)
    article.css("p, img").each do |element|
      # If the element is an image, download it and replace the src with the local file path
      if element.name == "img"
        img_url = element['src']
        next if img_url.nil?
        img_data = URI.open(img_url).read
        File.open("#{image_path}#{File.basename(img_url)}", "wb") do |f|
          f.write(img_data)
        end
        element["src"] = "#{image_path}#{File.basename(img_url)}"
      end

      # Add the element to the content as HTML
      content += element.to_html
    end

    # Save the article to the "Article" table in your Rails site
    # article = Article.create(title: title, content: content, created_at: created_at)

    puts title
    puts created_at
    puts content
  end
end
