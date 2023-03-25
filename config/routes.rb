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
      match 'setting' => '/application#setting', via: [:get, :put]
    end
  end
  
  # Defines the root path route ("/")
  # root "articles#index"
  root :to => "application#index"
  mount ExceptionTrack::Engine => "/err", constraints: AdminConstraint.new
  get '/err', to: redirect('/404.html')
  match "*path", to: "application#index", format: false, via: :get
end
