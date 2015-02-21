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
  get '/users/session_proposals'       => 'session_proposals#for_current_user', defaults: { format: :json }
  get '/users/voted_session_proposals' => 'session_proposals#voted_for_current_user', defaults: { format: :json }
  get '/users/reviews'                 => 'reviews#for_current_user', defaults: { format: :json }

  resources :session_proposals, except: [:destroy], defaults: { format: :json } do
    collection do
      get 'search'
    end
    resources :comments, only: [:index, :create]
    resources :reviews, only: [:create]
  end

  resources :tags, only: [:index], defaults: { format: :json } do
    collection do
      get 'suggest'
    end
  end

  root 'main#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
