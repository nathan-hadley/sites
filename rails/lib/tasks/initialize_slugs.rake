# Execute bundle exec rake initialize_slugs
task initialize_slugs: :environment do
  Article.find_each do |article|
    article.slug = article.title.downcase.gsub(": ", "-").gsub(" ", "-").gsub(".", "-")
    article.save
  end
end