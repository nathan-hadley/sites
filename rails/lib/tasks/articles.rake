# Execute bundle exec rake articles:route_setter_to_software_engineer
namespace :articles do
  task route_setter_to_software_engineer: :environment do
    text = File.read("lib/assets/career_change.txt")

    article = Article.find_by(title: 'Route Setter to Software Engineer')
    if article
      if article.update(content_html: text)
        puts "Article updated!"
      else
        puts "Article not updated"
        puts article.errors.full_messages
      end
    else
      article = Article.new(
        title: "Route Setter to Software Engineer",
        slug: "route-setter-to-software-engineer",
        header_image_html: "<figure class='header-img'><img src='/assets/SBP_DTTB_Burton_Routesetters__050.jpg' alt='SBP_DTTB_Burton_Routesetters__050.jpg'/></figure>",
        publish_date: Time.zone.now,
        content_html: text,
        category: 'software'
      )

      if article.save
        puts "Article saved!"
      else
        puts "Article not saved"
        puts article.errors.full_messages
      end
    end

  end
end
