class Article < ApplicationRecord
  paginates_per 3

  default_scope { order(publish_date: :desc) }

  validates :header_image_html, :title, :publish_date, :content_html, presence: true
end
