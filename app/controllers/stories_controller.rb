class StoriesController < ApplicationController
  def index
    @articles = Article.all
  end
end
