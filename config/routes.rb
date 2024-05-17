Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "archives" => "archives#index"
  get "archive/:month" => "archives#show", as: :archive

  get "email/:message_id" => "email#show", as: :email, message_id: /.*/

  resources :chats, only: [:index, :create]

  # Defines the root path route ("/")
  root "archives#index"
end
