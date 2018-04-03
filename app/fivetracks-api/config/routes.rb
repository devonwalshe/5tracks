Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions'}
  ### Artists
  jsonapi_resources :artists
  jsonapi_resources :artist_aliases
  jsonapi_resources :artist_urls
  jsonapi_resources :artist_name_variations
  ### Releases
  jsonapi_resources :releases do
    member do
      post :tracks_to_queue
    end
    jsonapi_relationships
  end
  jsonapi_resources :release_videos
  jsonapi_resources :release_labels
  jsonapi_resources :release_styles
  jsonapi_resources :release_genres
  jsonapi_resources :release_formats
  jsonapi_resources :release_companies
  jsonapi_resources :release_artists
  jsonapi_resources :release_tracks
  jsonapi_resources :release_track_artists
  jsonapi_resources :release_identifiers

  ### Labels
  jsonapi_resources :labels
  jsonapi_resources :label_urls

  # jsonapi_resources :search_tracks
  jsonapi_resources :queue_tracks

  ### Search
  get 'search-tracks', to: 'search#es_search'
  
  ### Current User
  get 'users/me', to: 'users#me'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
