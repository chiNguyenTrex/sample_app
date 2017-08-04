Rails.application.routes.draw do
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/help", to: "static_pages#help" # get "static_pages/home"
  get "/about", to: "static_pages#about" # get "static_pages/about"
  get "/contact", to: "static_pages#contact" # get "static_pages/contact"
  root "static_pages#home"
  resources :users
end
