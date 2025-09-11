# Execute bundle exec rake edit_article
task edit_article: :environment do
  article = Article.find_by(title: "Vanishing Point 2.0: A Classic Route Modernized")
  article.content_html.gsub!("B35CB462-501E-4881-BB68-13793EEE5400.JPG", "Dolomite-Tower-Approach-Slabs.jpg")
  article.content_html.gsub!("00100lrPORTRAIT_00100_BURST20200825104505085_COVER%7E2", "Dolomite-Tower-Approach-Slabs-2.jpg")
  article.content_html.gsub!("Dolomite-Tower-Approach-Slabs-2.jpg", "Dolomite-Tower-Approach-Slabs-2")
  article.save
end