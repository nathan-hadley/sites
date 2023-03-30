class StoriesController < ApplicationController
  before_action :set_articles

  def index
    @articles_on_page = Article.page(params[:page])
  end

  def show
    @article = Article.find_by(slug: params[:slug])
  end

  private

  # Done before both index (paginated articles) and show (individual article).
  def set_articles
    articles = Article.all
    articles_within_years = {}
    articles.each do |article|
      year = article.publish_date.strftime("%Y")
      articles_within_years[year] ||= []
      articles_within_years[year] << article
    end
    @articles_within_years = articles_within_years
  end
end
