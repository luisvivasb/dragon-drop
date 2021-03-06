Rails.application.routes.draw do

  root 'static_pages#root'

  namespace :api, defaults: { format: :json } do
    resources :layouts, only: [:index, :create]
    resources :sites, only: [:index, :create, :show, :destroy, :update] do
      resources :pages, only: [:index, :create]
      member do
        post :deploy
      end
    end
    resources :templates, only: [:index] do
      member do
        post :clone
      end
    end
    resources :pages, only: [:update, :destroy, :show] do
      resources :components, only: [:create]
    end
    resources :components, only: [:destroy]
    resources :users, only: [:create, :destroy]
    resource :session, only: [:create, :destroy]
    get 'view/site/:site_id/:page_id', to: 'views#view'
    get 'view/site/:site_id', to: 'views#view'
    get 'view/page/:page_id', to: 'views#view'
  end

end
