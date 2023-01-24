class Article < ApplicationRecord
  attr_accessor :created_at

  validates :title, :header_image_html, :content_html, presence: true
end
