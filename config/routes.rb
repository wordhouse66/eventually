Rails.application.routes.draw do
    devise_for :users do
	  resources :events
	end



resources :events
  root 'events#index'
  get 'tags/:tag', to: 'events#index', as: :tag
  get :join, to: 'events#join', as: 'join'
  get  :accept_request, to: 'events#accept_request', as: 'accept_request'
  get  :reject_request, to: 'events#reject_request', as: 'reject_request'
  get  :my_events, to: 'events#my_events', as: 'my_events'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
