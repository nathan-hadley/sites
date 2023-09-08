require "rails_helper"

RSpec.describe StoriesController, type: :controller do
  before do
    @climbing_article1 = create(:article, category: Article::CLIMBING, publish_date: Date.new(2021, 1, 1))
    @climbing_article2 = create(:article, category: Article::CLIMBING, publish_date: Date.new(2021, 1, 2))
    @software_article = create(:article, category: Article::SOFTWARE, publish_date: Date.new(2021, 1, 3))
  end

  describe "GET #index" do
    it "assigns the correct stories for the default climbing category" do
      get :index
      expect(assigns(:stories_on_page)).to match_array([@climbing_article1, @climbing_article2])
    end

    it "assigns the correct stories for a given category" do
      get :index, params: { category: Article::SOFTWARE }
      expect(assigns(:stories_on_page)).to match_array([@software_article])
    end

    it "paginates the stories" do
      # Create more articles to ensure pagination kicks in.
      Article.delete_all
      4.times do
        create(:article, category: Article::CLIMBING)
      end

      get :index, params: { page: 2 }
      expect(assigns(:stories_on_page).count).to eq(1)
    end
  end

  describe "GET #show" do
    it "assigns the correct story based on slug" do
      get :show, params: { slug: @climbing_article1.slug }
      expect(assigns(:story)).to eq(@climbing_article1)
    end
  end

  describe "before_action :set_stories" do
    it "initializes @stories_within_years with categorized stories grouped by year" do
      get :index
      expect(assigns(:stories_within_years))
        .to include("2021" => match_array([@climbing_article1, @climbing_article2])
                                                )
    end

    it "sets the correct default category" do
      get :index
      expect(assigns(:category)).to eq(Article::CLIMBING) # Assuming "climbing" is the default.
    end

    it "sets the category from params" do
      get :index, params: { category: Article::SOFTWARE }
      expect(assigns(:category)).to eq(Article::SOFTWARE)
    end
  end
end
