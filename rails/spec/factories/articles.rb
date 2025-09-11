FactoryBot.define do
  factory :article do
    title { "Title #{rand(1..1000)}" }
    slug { title.downcase.gsub(" ", "-") }
    category { Article::CLIMBING }
    content_html { "content" }
    header_image_html { "header" }
    publish_date { Time.zone.today }
  end
end
