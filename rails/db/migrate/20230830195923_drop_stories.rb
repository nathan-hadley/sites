class DropStories < ActiveRecord::Migration[7.0]
  def up
    drop_table :stories
  end

  def down
    create_table :stories do |t|
      t.string :title, index: true
      t.string :slug, index: true
      t.string :header_image_html
      t.string :content_html
      t.datetime :publish_date, index: true
      t.timestamps
    end
  end
end
