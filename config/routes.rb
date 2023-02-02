Rails.application.routes.draw do
  root 'verify_requests#new'

  resources :verify_requests, only: %i[new create]
  get '/verify_requests/result', to: 'verify_requests#result'
  post '/callback', to: 'application#callback'
end
