Rails.application.routes.draw do

  root 'home#index'

  resources :time_zones, only: [:index]

end
