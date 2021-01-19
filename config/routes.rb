Rails.application.routes.draw do
  #scope "(:lang)", locale: /#{I18n.available_locales.join("|")}/ do
    root to: "welcome#index"
    devise_for :users, controllers: {:registrations => "users/registrations"}
    resources :users, only: [:show]
    resources :customers, only: [:show]
    resources :welcome, only: [:index]
    resources :cart, only: [:show, :update, :destroy]
    resources :orders, only: [:create, :show, :update]

    # devise_for :users, controllers: {:sessions => "users/sessions", :passwords => "users/passwords", :registrations => "users/registrations"}
    # resources :users, only: [:show]
    # resources :customers, only: [:show]
    # resources :welcome, only: [:index]
    # resources :cart, only: [:show, :update, :destroy]
    # resources :orders, only: [:create, :show]

    namespace :admin do
      resources :merchants, except: [:destroy]
      resources :merchants_status, only: [:update]
      resources :invoices, only: [:index, :show, :update]
    end

    resources :merchants, module: :merchant do
      resources :items
      resources :bulk_discounts
      resources :items_status, controller: "merchant_items_status", only: [:update]
      resources :invoices
      resources :invoice_items, only: [:update]
      resources :dashboard, only: [:index]
    end


    resources :admin, controller: 'admin/dashboard', only: [:index]
  #end
end
