Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "recipes#index"

  resources :recipes, only: [:index, :show]
end
