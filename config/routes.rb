Rails.application.routes.draw do
  # root 'base#index'
  get 'search' => 'base#search'
  # post 'refresh_locations' => 'base#refresh_locations'
  # post 'callback' => 'base#callback'
  # get 'webhook' => 'base#webhook'
  # post 'webhook' => 'base#facebook_callback'
  # get 'privacy' => 'base#privacy'

  # resources :chat_rooms, only: [:index, :show] do
  #   resources :users, only: :index
  # end

  root :to => "rooms#index"
  resources :rooms
  match '/party/:id', :to => "rooms#party", :as => :party, :via => :get


  namespace :naver_lines do
    post :webhooks, :to => "application#webhooks"
  end
end
