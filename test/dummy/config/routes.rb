Dummy::Application.routes.draw do
  resources :locations
  root 'locations#index'
end
