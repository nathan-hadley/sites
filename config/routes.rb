Rails.application.routes.draw do
  root 'stories#index'

  resources 'stories', only: [:index, :show], param: :slug
  resources 'photos', only: :index
  resources 'about', only: :index
end
