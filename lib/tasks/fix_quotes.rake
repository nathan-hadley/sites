# Execute bundle exec rake fix_quotes
task fix_quotes: :environment do
  Article.find_each do |article|
    article.header_image_html.gsub!("''", "'")
    article.content_html.gsub!("''", "'")
    article.save
  end
end