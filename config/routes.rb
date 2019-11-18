Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'welcome/index'

  resources :groups, :buddies, :notes, :discussions

  resources :courses do 
    resources :links
  end

  match '/home' => 'welcome#index', via: [:get, :post]
  match '/about' => 'welcome#about', via: [:get, :post]
  match '/contact' => 'welcome#contact', via: [:get, :post]
  root 'welcome#welcome'
end
