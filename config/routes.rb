Rails.application.routes.draw do
  root 'stories#index'

  get 'stories/index'
  get 'photos/index'
  get 'about/index'
end
