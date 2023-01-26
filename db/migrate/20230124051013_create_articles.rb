class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title, index: true
      t.string :slug, index: true
      t.string :header_image_html
      t.string :content_html
      t.datetime :publish_date, index: true
      t.timestamps
    end
  end
end
