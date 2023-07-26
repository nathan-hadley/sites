Rails.application.routes.draw do
  root 'stories#index'

  resources 'stories', only: [:index, :show], param: :slug do
    get '/page/:page', action: :index, on: :collection
    get '/category/:category', action: :index, on: :collection
  end

  # redirect old urls with a date before the slug to new urls without the date
  get '/stories/*all/:story_slug', to: redirect('stories/%{story_slug}')

  resources 'photos', only: :index
  resources 'about', only: :index
  resources 'snow', only: :index
end
