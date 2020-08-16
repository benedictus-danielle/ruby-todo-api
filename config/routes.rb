Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api' do
    resources :todos
    post '/login', to: 'users#login'
    post '/register', to: 'users#create'
    post '/token/verify', to: 'users#verify_token'
  end
end
