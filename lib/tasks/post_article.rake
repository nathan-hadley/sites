# Execute bundle exec rake post_article
task post_article: :environment do
  text = File.read("lib/assets/red_rocks.txt")

  article = Article.find_by(title: 'Dreefee and Crystal Dawn')
  if article
    if article.update(content_html: text)
      puts "Article updated!"
    else
      puts "Article not updated"
      puts article.errors.full_messages
    end
  else
    article = Article.new(
      title: "Dreefee and Crystal Dawn",
      slug: "dreefee-and-crystal-dawn",
      header_image_html: "<figure class='header-img'><img src='/assets/Red-Rocks-Crystal-Dawn-Sunset.jpeg' alt='Red-Rocks-Crystal-Dawn-Sunset.jpeg'/></figure>",
      publish_date: Time.zone.now,
      content_html: text
    )

    if article.save
      puts "Article saved!"
    else
      puts "Article not saved"
      puts article.errors.full_messages
    end
  end

end
