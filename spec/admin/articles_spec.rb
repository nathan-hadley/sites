require "rails_helper"

RSpec.describe "Admin::Articles", type: :request do
  let(:admin) { create(:admin_user) }
  let(:article) { create(:article) }

  describe "PUT /admin/articles/:id" do
    context "when not logged in" do
      it "redirects to the login page" do
        put admin_article_path(article), params: { article: { title: "New Title" } }
        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context "when logged in" do
      it "allows updating the article" do
        sign_in admin
        expect(Article.first.title).to_not eq "New Title"
        put admin_article_path(article), params: { article: { title: "New Title" } }
        expect(Article.first.title).to eq "New Title"
      end
    end
  end

  context "member methods" do
    before { sign_in admin }

    describe "POST /admin/articles/:id/upload" do
      it "attaches an image" do
        image = Rack::Test::UploadedFile.new("spec/fixtures/example_image.jpg", "image/jpeg")
        post upload_admin_article_path(article), params: { file_upload: image }
        expect(article.reload.images).to be_attached
      end
    end

    describe "DELETE /admin/articles/:id/purge" do
      it "deletes an attached image" do
        article.images.attach(io: File.open(Rails.root.join("spec", "fixtures", "example_image.jpg")),
                              filename: "example_image.jpg", content_type: "image/jpeg")

        image_id = article.images.last.id
        delete purge_admin_article_path(article), params: { image_id: image_id }

        expect(response).to redirect_to(edit_admin_article_path(article))
        follow_redirect!
        expect(response.body).to include("Image deleted.")
      end
    end
  end
end
