Rails.application.routes.draw do

  root 'messenger#index'

  get 'messenger/index'
  post '/' => 'messenger#recieved_data'
  resources :session

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
