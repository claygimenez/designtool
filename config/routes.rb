Designtool::Application.routes.draw do
  get "projects/(*backbone)" => 'projects#index'
  resources :projects, only: [:index, :create, :new]

  root to: 'projects#index'
end
