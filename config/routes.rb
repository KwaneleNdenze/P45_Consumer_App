Rails.application.routes.draw do
  root 'pets#index'
  get 'login', to: 'users#login'
  post 'logout', to: 'users#logout'
  post 'authenticate', to: 'users#authenticate'

  get 'vet_registration/:id', to: 'vet_registrations#new', as: 'new_pet_vet_registration'
  get 'appointment/pet/:id/appointment/:vet_id', to: 'appointments#new', as: 'new_pet_vet_appointment'

  get 'vet/:id/pets', to: 'vets#index', as: 'vet_pets'
  get 'vet/pets/:id', to: 'vets#show', as: 'vet_pet'
  resources :users
  resources :pets
  resources :vet_registrations
  resources :appointments
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
