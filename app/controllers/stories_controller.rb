class StoriesController < ApplicationController
  before_action :set_stories

  def index
    @stories_on_page = Story.page(params[:page])
  end

  def show
    @story = Story.find_by(slug: params[:slug])
  end

  def edit
    @story = Story.find_by(slug: params[:slug])
  end

  def new
    @story = Story.new
  end

  private

  # Done before both index (paginated stories) and show (individual story).
  def set_stories
    stories = Story.all
    stories_within_years = {}
    stories.each do |story|
      year = story.publish_date.strftime("%Y")
      stories_within_years[year] ||= []
      stories_within_years[year] << story
    end
    @stories_within_years = stories_within_years
  end
end
