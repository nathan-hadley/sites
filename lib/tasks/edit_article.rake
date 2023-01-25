# Execute bundle exec rake edit_article
task edit_article: :environment do
  article = Article.find_by(title: "First Route in the Alaska Range")
  article.content_html.gsub!(" class='left'", "")
  article.content_html.gsub!("<p></p>", "")
  article.content_html.gsub!("<p ></p>", "")
  article.content_html.gsub!("\n", "")

  #article.content_html.gsub!("<p>Beta:</p>", "<h3>Beta</h3>")
  article.save
end