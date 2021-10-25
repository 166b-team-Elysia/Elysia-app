Rails.application.routes.draw do
  
  get 'users/new'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  devise_for :users
  # root 'application'
  root 'customer/home#home'
  # root 'static_pages#home'
  # root 'users#users'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
