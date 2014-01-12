MasterChef::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' }

  # Authentication
  devise_scope :user do
    get '/login' => 'devise/sessions#new', as: :login
    get '/logout' => 'devise/sessions#destroy', as: :logout
    get '/signup' => 'registrations#new', as: :signup
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  authenticate do
    root 'projects#index'
  end

  resources :projects, shallow: true do
    resources :roles
    resources :nodes do
      resources :deployments, only: :create
    end
    resources :deployments, only: [:index, :show]
    resource :cookbook, only: [:update]
  end


  unauthenticated do
    as :user do
      root to: 'devise/sessions#new', as: 'unauthenticated_root'
    end
  end

  authenticate :user, ->(u) { u.superadmin? } do
    get "/delayed_job" => DelayedJobWeb, :anchor => false
    put "/delayed_job" => DelayedJobWeb, :anchor => false
    post "/delayed_job" => DelayedJobWeb, :anchor => false
  end

  ActiveAdmin.routes(self)

end
