Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations" }

  get '/templates/:path.html' => 'templates#template', :constraints => { :path => /.+/ }

  namespace :users do
    get '/reset_password'    => 'users#reset_password'
    get '/unlink_social'     => 'users#unlink_social'
    get '/session_voted_ids' => 'users#session_proposal_voted_ids', defaults: { format: :json }
    get '/session_faved_ids' => 'users#session_proposal_faved_ids', defaults: { format: :json }
    post '/vote_session'     => 'users#toggle_session_vote'
    post '/fav_session'      => 'users#toggle_session_fav'
  end
  get '/users/session_proposals'           => 'session_proposals#for_current_user', defaults: { format: :json }
  get '/users/voted_session_proposals'     => 'session_proposals#voted_for_current_user', defaults: { format: :json }
  get '/users/faved_session_proposals'     => 'session_proposals#faved_for_current_user', defaults: { format: :json }
  get '/users/reviews'                     => 'reviews#for_current_user', defaults: { format: :json }
  get '/users/review/:session_proposal_id' => 'reviews#single_for_current_user', defaults: { format: :json }

  resources :session_proposals, except: [:destroy], defaults: { format: :json } do
    collection do
      get :search
    end
    member do
      get :author
    end
    resources :comments, only: [:index, :create]
    resources :reviews, only: [:index, :create] do
      member do
        post :accept
        post :reject
      end
    end
  end

  resources :tags, only: [:index], defaults: { format: :json } do
    collection do
      get :suggest
    end
  end

  resources :roles, only: [:index, :update, :destroy]

  resources :stats, only: [:index, :show], defaults: { format: :json }

  resources :notifications, only: [:index], defaults: { format: :json }

  root 'main#index'
end
