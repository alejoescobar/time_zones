Rails.application.routes.draw do

  root 'home#index'

  resources :time_zones, only: [:index]

  # Auth module
  scope :user do
    post "sign_up", to: "registrations#create"
  end

end
