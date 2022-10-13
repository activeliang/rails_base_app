Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post 'login' => 'session#create'
      post 'refresh' => 'session#refresh'
      delete 'logout' => 'session#destroy'

      resources :users do
        put :reset_password, on: :member
      end
    end
  end
  
  # Defines the root path route ("/")
  # root "articles#index"
  root :to => "application#index"
  # mount ExceptionTrack::Engine => "/err"
  match "*path", to: "application#index", format: false, via: :get
end