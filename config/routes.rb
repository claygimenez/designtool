Designtool::Application.routes.draw do
  get "projects/(*backbone)" => 'projects#index'
  resources :projects, only: :index

  root to: 'projects#index'
end
