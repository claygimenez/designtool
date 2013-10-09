Designtool::Application.routes.draw do
  resources :projects, only: :index

  root to: 'projects#index'
end
