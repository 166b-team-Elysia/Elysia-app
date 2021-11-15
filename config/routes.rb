Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  namespace :customer do
    resources :users do
      collection do
        get :signup, to: 'users#new'
      end
    end
    resources :stores do
      resources :products
    end

    resources :carts do
      collection do
        post :add, to: 'carts#add'
        delete :destroy, to: 'carts#destroy'
      end
    end
  end

  resources :sessions do
    collection do
      get :login, to: "sessions#new"
      post :login,  to: 'sessions#create'
      delete :logout,  to: 'sessions#destroy'
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
