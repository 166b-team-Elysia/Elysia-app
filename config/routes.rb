Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  get '/search', to: 'static_pages#search'
  get '/search_result', to: 'static_pages#result'
  get 'static_pages/show'
  get  '/conversations',    to: 'conversations#index'
  get '/edit', to: 'customer/products#new'
  get 'full_width', to: 'static_pages#full_width'

  resources :conversations do
    resources :messages
  end

  namespace :customer do
    resources :users do
      collection do
        get :signup, to: 'users#new'
      end
    end
    resources :stores do
      resources :products
    end

    resources :products do
      get :add, to: 'products#new'
      post :add, to: 'products#new'
      post :add_review, to: 'products#add_review'
    end

    resources :carts do
      collection do
        patch :update, to: 'carts#update'
        post :add, to: 'carts#add'
        delete :destroy, to: 'carts#destroy'
      end
    end

    resources :orders do
      collection do
        patch :create, to: 'orders#create'
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
