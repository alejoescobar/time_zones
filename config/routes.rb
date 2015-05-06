Rails.application.routes.draw do

  root 'home#index'

  resources :time_zones, only: [:index,:create,:update,:destroy,:show]

  # Auth module
  scope :user do
    post "sign_up", to: "registrations#create"

    post "sign_in", to: "sessions#create"
    delete "sign_out", to: "sessions#destroy"
    get "", to: "sessions#show", as: :current_session

  end

end
