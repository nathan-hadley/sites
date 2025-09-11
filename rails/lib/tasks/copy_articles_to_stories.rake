# Execute bundle exec rake copy_articles_to_stories
task copy_articles_to_stories: :environment do
  Article.find_each do |article|
    # Skip articles that have already been copied to stories.
    next if Story.find_by(slug: article.slug)

    story = Story.new
    story.title = article.title
    story.slug = article.slug
    story.header_image_html = article.header_image_html
    story.content_html = article.content_html
    story.publish_date = article.publish_date
    story.save
  end
end