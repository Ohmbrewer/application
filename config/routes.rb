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

  resources :schedules
  resources :schedules do
    post 'duplicate' => 'schedules#duplicate'
    collection do
      delete :destroy_multiple
    end
  end

  resources :recipes
  resources :recipes do
    post 'duplicate' => 'recipes#duplicate'
    collection do
      delete :destroy_multiple
    end
  end
  resources :beer_recipes, controller: 'recipes', type: 'BeerRecipe'
  resources :distilling_recipes, controller: 'recipes', type: 'DistillingRecipe'
  resources :cider_recipes, controller: 'recipes', type: 'CiderRecipe'
  resources :mead_recipes, controller: 'recipes', type: 'MeadRecipe'
  resources :wine_recipes, controller: 'recipes', type: 'WineRecipe'

  resources :equipments
  resources :equipments do
    collection do
      delete :destroy_multiple
    end
  end
  resources :equipment, controller: 'equipments', type: 'Equipment' # Compensates for the janky pluralization
  resources :pumps, controller: 'equipments', type: 'Pump'
  resources :heating_elements, controller: 'equipments', type: 'HeatingElement'
  resources :temperature_sensors, controller: 'equipments', type: 'TemperatureSensor'
  resources :thermostats
  resources :thermostats do
    collection do
      delete :destroy_multiple
    end
  end
  resources :recirculating_infusion_mash_systems
  resources :recirculating_infusion_mash_systems do
    collection do
      delete :destroy_multiple
    end
  end
  resources :rims, controller: 'recirculating_infusion_mash_systems' # Compensates for the stupid-long name

  scope :jobs, controller: :jobs, shallow: true do
    post 'ping'
    # get  'dashboard'
  end

  # Provide webhooks for our HOPS... HOPhooks, if you will...
  scope '/hooks/v1', :controller => :hooks do
    post :pump
    post :temp
    post :heat
  end

  # # Paths under this controller are used with SSE to stream status updates
  # scope :status_updates, controller: :status_updates, shallow: true do
  #   get :pumps
  #   get :temps
  # end

end
