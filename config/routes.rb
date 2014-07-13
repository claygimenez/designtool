Designtool::Application.routes.draw do
  resources :projects
  resources :notes

  root to: 'projects#index'
end
