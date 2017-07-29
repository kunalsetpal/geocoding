Rails.application.routes.draw do
  get 'coordinates/new'
  root :to => 'coordinates#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :coordinates
end
