Rails.application.routes.draw do
  root 'stories#index'
  get 'photos/index'
  get 'about/index'
  get 'stories/index'
end
