Rails.application.routes.draw do
  root 'home#index'

  resources 'home', only: :index
  resources 'about', only: :index
  get 'focus-areas', to: 'focus_areas#index', as: 'focus_areas'
  resources 'faq', only: :index
  resources 'resources', only: :index
  resources 'contact', only: :index
end
