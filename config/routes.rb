MasterChef::Application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  resources :projects do
    resources :roles
    resources :nodes do
      resources :deployments, only: [:create]
    end
    resources :deployments, only: [:index, :show]
    resource :cookbook, only: [:update], defaults: {format: :json}
  end

  resources :nodes, only: [:destroy, :show, :edit, :update]
  resources :roles, only: [:destroy, :show, :edit, :update]

  resources :deployments, only: [:index, :show]

  root 'pages#home'
end
