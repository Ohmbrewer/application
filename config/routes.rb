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
      post :destroy_multiple
    end
    # Provide a way to add a Particle webhook. Might want to refactor/automate this somehow...
    resources :hooks, only: [:index, :new, :create, :destroy]
  end

  resources :equipment_profiles
  resources :equipment_profiles do
    post 'duplicate' => 'equipment_profiles#duplicate'
    collection do
      post :destroy_multiple
    end
  end

  # The user will never edit the Batch directly
  resources :batches, only: [:index, :new, :create, :destroy]
  resources :batches do
    post 'start' => 'batches#start'
    post 'stop'  => 'batches#stop'
    get 'assign_rhizomes'  => 'batches#assign_rhizomes'
    patch 'update_rhizomes'  => 'batches#update_rhizomes'
  end

  resources :schedules
  resources :schedules do
    post 'duplicate' => 'schedules#duplicate'
    post 'run'       => 'jobs#schedule'
    post 'run_task'  => 'jobs#task'
    collection do
      post :destroy_multiple
    end
  end

  resources :tasks do
    post 'run'  => 'jobs#task'
  end

  resources :recipes
  resources :recipes do
    post 'duplicate' => 'recipes#duplicate'
    collection do
      post :destroy_multiple
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
      post :destroy_multiple
    end
  end
  resources :equipment, controller: 'equipments', type: 'Equipment' # Compensates for the janky pluralization
  resources :pumps, controller: 'equipments', type: 'Pump'
  resources :heating_elements, controller: 'equipments', type: 'HeatingElement'
  resources :temperature_sensors, controller: 'equipments', type: 'TemperatureSensor'
  resources :thermostats
  resources :thermostats do
    collection do
      post :destroy_multiple
    end
  end
  resources :recirculating_infusion_mash_systems
  resources :recirculating_infusion_mash_systems do
    collection do
      post :destroy_multiple
    end
  end
  resources :rims, controller: 'recirculating_infusion_mash_systems' # Compensates for the stupid-long name

  scope :jobs, controller: :jobs, shallow: true do
    post 'ping'
    post 'add_sprouts'
    post 'clear_sprouts'
    # get  'dashboard'
  end

  # Provide webhooks for our HOPS... HOPhooks, if you will...
  scope '/hooks/v1', :controller => :hooks do
    post :pump
    post :temp
    post :heat
  end

  # Paths under this controller are used with SSE to stream status updates
  scope :status_updates, controller: :status_updates, shallow: true do
    get :pumps
    get :temps
    get :heats
  end
end
