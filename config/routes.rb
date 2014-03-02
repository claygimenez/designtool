Designtool::Application.routes.draw do
  get "projects/(*backbone)" => 'projects#index'
  resources :projects
  resources :notes

  root to: 'projects#index'
end
