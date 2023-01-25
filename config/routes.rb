Rails.application.routes.draw do
  root 'stories#index'

  resources 'stories', only: [:index, :show], param: :slug do
    get '/page/:page', action: :index, on: :collection
  end

  resources 'photos', only: :index
  resources 'about', only: :index
end
