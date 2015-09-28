Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'

  root 'sessions#new'
  get  'home'    => 'static_pages#home'
  get  'help'    => 'static_pages#help'
  get  'about'   => 'static_pages#about'
  get  'contact' => 'static_pages#contact'
  resources :users
  get  'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  resources :rhizomes
  resources :rhizomes do
    collection do
      delete :destroy_multiple
    end
    # Provide a way to add a Particle webhook. Might want to refactor/automate this somehow...
    resources :hooks, only: [:index, :new, :create, :destroy]
  end

  scope :jobs, controller: :jobs, shallow: true do
    post 'ping'
    post 'pump'
    # get  'dashboard'
  end

  # Provide webhooks for our HOPS... HOPhooks, if you will...
  scope '/hooks/v1', :controller => :hooks do
    post :pumps
  end

  # # Paths under this controller are used with SSE to stream status updates
  # scope :status_updates, controller: :status_updates, shallow: true do
  #   get :pumps
  # end

end
