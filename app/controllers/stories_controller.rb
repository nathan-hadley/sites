class StoriesController < ApplicationController
  before_action :set_articles

  def index; end

  def show
    @article = Article.find_by(slug: params[:slug])
  end

  private

  def set_articles
    @articles = Article.all
  end
end
